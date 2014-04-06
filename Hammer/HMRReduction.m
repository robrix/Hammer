//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRNull.h"
#import "HMRReduction.h"

@implementation HMRReduction

-(instancetype)initWithCombinator:(id<HMRCombinator>)combinator block:(HMRReductionBlock)block {
	if ((self = [super init])) {
		_combinator = [combinator copyWithZone:NULL];
		_block = [block copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	id<HMRCombinator> combinator = self.combinator;
	HMRReductionBlock block = self.block;
	return HMRReduce([combinator derivative:object], block);
}


-(bool)computeNullability {
	return self.combinator.nullable;
}


-(bool)computeCyclic {
	return self.combinator.cyclic;
}


-(NSSet *)reduceParseForest {
	return [[NSSet set] red_append:REDMap(self.combinator.parseForest, ^(id tree) {
		return self.block(tree);
	})];
}


static inline HMRReduction *HMRComposeReduction(HMRReduction *reduction, id<NSObject, NSCopying>(^g)(id<NSObject, NSCopying>)) {
	HMRReductionBlock f = reduction.block;
	return HMRReduce(reduction.combinator, ^(id<NSObject, NSCopying> x) { return g(f(x)); });
}

-(id<HMRCombinator>)compact {
	id<HMRCombinator> combinator = self.combinator.compaction;
	return [combinator isKindOfClass:[HMRReduction class]]?
		HMRComposeReduction(combinator, self.block)
	:	(combinator == self.combinator? self : HMRReduce(combinator, self.block));
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@ → 𝑓", self.combinator.name ?: self.combinator.description];
}

-(NSSet *)prettyPrint {
	return [[super prettyPrint] setByAddingObjectsFromSet:self.combinator.prettyPrinted];
}

@end


id<HMRCombinator> HMRReduce(id<HMRCombinator> combinator, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>)) {
	NSCParameterAssert(combinator != nil);
	NSCParameterAssert(block != nil);
	
	return [[HMRReduction alloc] initWithCombinator:combinator block:block];
}
