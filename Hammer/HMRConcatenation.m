//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMRConcatenation.h"
#import "HMREmpty.h"
#import "HMRLazyCombinator.h"
#import "HMRNull.h"
#import "HMRNullabilityCombinator.h"

@implementation HMRConcatenation

+(instancetype)combinatorWithFirst:(id<HMRCombinator>)first second:(id<HMRCombinator>)second {
	return [[self alloc] initWithFirst:first second:second];
}

-(instancetype)initWithFirst:(id<HMRCombinator>)first second:(id<HMRCombinator>)second {
	if ((self = [super init])) {
		_first = [first copyWithZone:NULL];
		_second = [second copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
	Class class = self.class;
	id<HMRCombinator> first = self.first;
	id<HMRCombinator> second = self.second;
	return [HMRLazyCombinator combinatorWithBlock:^{
		id<HMRCombinator>left = [class combinatorWithFirst:[first memoizedDerivativeWithRespectToElement:element]
														   second:second];
		id<HMRCombinator>right = [class combinatorWithFirst:[HMRNullabilityCombinator combinatorWithParser:first]
															second:[second memoizedDerivativeWithRespectToElement:element]];
		return [HMRAlternation combinatorWithLeft:left right:right];
	}];
}


-(NSSet *)deforest {
	NSMutableSet *trees = [NSMutableSet new];
	for (id eachFirst in self.first.deforestation) {
		for (id eachSecond in self.second.deforestation) {
			[trees addObject:@[ eachFirst, eachSecond ]];
		}
	}
	return trees;
}


-(id<HMRCombinator>)compact {
	return (self.first.compaction == [HMREmpty parser] || self.second.compaction == [HMREmpty parser])?
		[HMREmpty parser]
	:	[super compact];
}

l3_test(@selector(compaction)) {
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = [HMREmpty parser];
	l3_expect(HMRConcatenate(empty, anything).compaction).to.equal(empty);
	l3_expect(HMRConcatenate(anything, empty).compaction).to.equal(empty);
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@ %@", self.first.description, self.second.description];
}

@end


id<HMRCombinator> HMRConcatenate(id<HMRCombinator> first, id<HMRCombinator> second) {
	return [HMRConcatenation combinatorWithFirst:first second:second];
}
