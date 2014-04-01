//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRNull.h"
#import "HMRReduction.h"

@implementation HMRReduction {
	HMRLazyCombinator _lazyCombinator;
	id<HMRCombinator> _combinator;
}

-(instancetype)initWithCombinator:(id<HMRCombinator>)combinator block:(HMRReductionBlock)block {
	if ((self = [super init])) {
		_combinator = [combinator copyWithZone:NULL];
		_block = [block copy];
	}
	return self;
}

-(instancetype)initWithLazyCombinator:(HMRLazyCombinator)lazyCombinator block:(HMRReductionBlock)block {
	if ((self = [super init])) {
		_lazyCombinator = lazyCombinator;
		_block = [block copy];
	}
	return self;
}


-(id<HMRCombinator>)combinator {
	if (!_combinator) {
		_combinator = HMRForce(_lazyCombinator);
		_lazyCombinator = nil;
	}
	return _combinator;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	id<HMRCombinator> combinator = self.combinator;
	HMRReductionBlock block = self.block;
	return HMRReduce(HMRDelay([combinator derivative:object]), block);
}


-(NSSet *)reduceParseForest {
	return [[NSSet set] red_append:REDMap(self.combinator.parseForest, ^(id tree) {
		return self.block(tree);
	})];
}


static inline HMRReduction *HMRComposeReduction(HMRReduction *reduction, id<NSObject, NSCopying>(^g)(id<NSObject, NSCopying>)) {
	HMRReductionBlock f = reduction.block;
	return HMRReduce(HMRDelay(reduction.combinator), ^(id<NSObject, NSCopying> x) { return g(f(x)); });
}

-(id<HMRCombinator>)compact {
	id<HMRCombinator> combinator = self.combinator.compaction;
	return [combinator isKindOfClass:[HMRReduction class]]?
		HMRComposeReduction(combinator, self.block)
	:	[[HMRReduction alloc] initWithCombinator:combinator block:self.block];
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@ → 𝑓", self.combinator.description];
}

@end


id<HMRCombinator> HMRReduce(HMRLazyCombinator lazyCombinator, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>)) {
	return [[HMRReduction alloc] initWithLazyCombinator:lazyCombinator block:block];
}
