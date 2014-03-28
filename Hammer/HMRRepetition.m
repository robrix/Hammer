//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMRConcatenation.h"
#import "HMREmpty.h"
#import "HMRLazyCombinator.h"
#import "HMRNullReduction.h"
#import "HMRReduction.h"
#import "HMRRepetition.h"

@implementation HMRRepetition

+(instancetype)combinatorWithParser:(id<HMRCombinator>)parser {
	return [[self alloc] initWithParser:parser];
}

-(instancetype)initWithParser:(id<HMRCombinator>)parser {
	if ((self = [super init])) {
		_parser = [parser copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	id<HMRCombinator> parser = self.parser;
	
	return [HMRLazyCombinator combinatorWithBlock:^{
		HMRConcatenation *concatenation = [HMRConcatenation combinatorWithFirst:[parser derivative:object]
																				 second:self];
		HMRReduction *reduction = [HMRReduction combinatorWithParser:concatenation block:^(id x) {
			return x; // ??
		}];
		return [HMRAlternation combinatorWithLeft:reduction right:[HMRNull parser]];
	}];
}


-(NSSet *)reduceParseForest {
	return [NSSet setWithObject:@[]];
}


-(id<HMRCombinator>)compact {
	return self.parser.compaction == [HMREmpty empty]?
		[HMRNullReduction combinatorWithObject:@[]]
	:	[super compact];
}

l3_test(@selector(compaction)) {
	l3_expect(HMRRepeat([HMREmpty empty]).compaction).to.equal([HMRNullReduction combinatorWithObject:@[]]);
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@*", self.parser.description];
}

@end


id<HMRCombinator> HMRRepeat(id<HMRCombinator> parser) {
	return [HMRRepetition combinatorWithParser:parser];
}
