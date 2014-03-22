//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMRConcatenation.h"
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

-(id<HMRCombinator>)derivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
	id<HMRCombinator> parser = self.parser;
	
	return [HMRLazyCombinator combinatorWithBlock:^{
		HMRConcatenation *concatenation = [HMRConcatenation combinatorWithFirst:[parser derivativeWithRespectToElement:element]
																				 second:self];
		HMRReduction *reduction = [HMRReduction combinatorWithParser:concatenation block:^(id x) {
			return x; // ??
		}];
		return [HMRAlternation combinatorWithLeft:reduction right:[HMRNullReduction combinatorWithElement:@[]]];
	}];
}


-(NSSet *)deforest {
	return [NSSet setWithObject:@[]];
}

@end


id<HMRCombinator> HMRRepeat(id<HMRCombinator> parser) {
	return [HMRRepetition combinatorWithParser:parser];
}
