//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMRConcatenation.h"
#import "HMREmpty.h"

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

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	Class class = self.class;
	id<HMRCombinator> first = self.first;
	id<HMRCombinator> second = self.second;
	return HMRDelay(^{
		NSSet *forest = first.parseForest;
		id<HMRCombinator> derivativeAfterFirst = [class combinatorWithFirst:[first derivative:object] second:second];
		return forest.count?
			HMRAlternate(derivativeAfterFirst, [class combinatorWithFirst:HMRCaptureForest(forest) second:[second derivative:object]])
		:	derivativeAfterFirst;
	});
}

l3_test(@selector(derivative:)) {
	id first = @"a";
	id second = @"b";
	id other = @"";
	id<HMRCombinator> concatenation = HMRConcatenate(HMRLiteral(first), HMRLiteral(second));
	l3_expect([[concatenation derivative:first] derivative:second].parseForest).to.equal([NSSet setWithObject:@[ first, second ]]);
	l3_expect([[concatenation derivative:first] derivative:other].parseForest).to.equal([NSSet set]);
}


-(NSSet *)reduceParseForest {
	NSMutableSet *trees = [NSMutableSet new];
	for (id eachFirst in self.first.parseForest) {
		for (id eachSecond in self.second.parseForest) {
			[trees addObject:@[ eachFirst, eachSecond ]];
		}
	}
	return trees;
}


-(id<HMRCombinator>)compact {
	return (self.first.compaction == [HMREmpty empty] || self.second.compaction == [HMREmpty empty])?
		[HMREmpty empty]
	:	[super compact];
}

l3_test(@selector(compaction)) {
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = [HMREmpty empty];
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
