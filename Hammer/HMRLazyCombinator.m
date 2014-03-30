//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLazyCombinator.h"

@implementation HMRLazyCombinator

-(instancetype)initWithBlock:(HMRLazyCombinatorBlock)block {
	if ((self = [super init])) {
		_block = [block copy];
	}
	return self;
}


@synthesize combinator = _combinator;

-(id<HMRCombinator>)force {
	_combinator = self.block();
	_block = nil;
	return _combinator;
}

-(id<HMRCombinator>)combinator {
	return _combinator ?: [self force];
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return [self.combinator derivative:object];
}


-(NSSet *)reduceParseForest {
	return self.combinator.parseForest;
}


-(id<HMRCombinator>)compact {
	return _combinator ?: self;
}


-(NSString *)describe {
	return self.combinator.description;
}

@end


id<HMRCombinator> HMRDelay(HMRLazyCombinatorBlock block) {
	return [[HMRLazyCombinator alloc] initWithBlock:block];
}
