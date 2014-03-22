//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLazyCombinator.h"

@implementation HMRLazyCombinator

+(instancetype)combinatorWithBlock:(HMRLazyCombinatorBlock)block {
	return [[self alloc] initWithBlock:block];
}

-(instancetype)initWithBlock:(HMRLazyCombinatorBlock)block {
	if ((self = [super init])) {
		_block = [block copy];
	}
	return self;
}


@synthesize parser = _parser;

-(id<HMRCombinator>)parser {
	return _parser ?: (_parser = self.block());
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id)element {
	return [self.parser derivativeWithRespectToElement:element];
}


-(NSSet *)deforest {
	return [self.parser deforest];
}

@end

id<HMRCombinator> HMRDelay(HMRLazyCombinatorBlock block) {
	return [HMRLazyCombinator combinatorWithBlock:block];
}