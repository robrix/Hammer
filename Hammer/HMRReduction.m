//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLazyCombinator.h"
#import "HMRReduction.h"

@implementation HMRReduction

+(instancetype)combinatorWithParser:(id<HMRCombinator>)parser block:(HMRReductionBlock)block {
	return [[self alloc] initWithParser:parser block:block];
}

-(instancetype)initWithParser:(id<HMRCombinator>)parser block:(HMRReductionBlock)block {
	if ((self = [super init])) {
		_parser = [parser copyWithZone:NULL];
		_block = [block copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id)element {
	id<HMRCombinator>parser = self.parser;
	HMRReductionBlock block = self.block;
	return [HMRLazyCombinator combinatorWithBlock:^{
		return [HMRReduction combinatorWithParser:[parser derivativeWithRespectToElement:element] block:block];
	}];
}


-(NSSet *)deforest {
	NSMutableSet *trees = [NSMutableSet new];
	for (id each in [self.parser deforest]) {
		[trees addObject:self.block(each)];
	}
	return trees;
}

@end
