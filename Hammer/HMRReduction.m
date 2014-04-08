//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRNull.h"
#import "HMRReduction.h"
#import <Reducers/REDReducer.h>

@implementation HMRReduction

-(instancetype)initWithCombinator:(id<HMRCombinator>)combinator block:(REDMapBlock)block {
	if ((self = [super init])) {
		_combinator = [combinator copyWithZone:NULL];
		_block = [block copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	id<HMRCombinator> combinator = self.combinator;
	REDMapBlock block = self.block;
	return HMRReduce([combinator derivative:object], block);
}


-(bool)computeNullability {
	return self.combinator.nullable;
}


-(bool)computeCyclic {
	return self.combinator.cyclic;
}


-(NSSet *)reduceParseForest {
	return [[NSSet set] red_append:REDMap(self.combinator.parseForest, self.block)];
}


static inline HMRReduction *HMRComposeReduction(HMRReduction *reduction, REDMapBlock g) {
	REDMapBlock f = reduction.block;
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

-(NSOrderedSet *)prettyPrint {
	NSMutableOrderedSet *prettyPrint = [[super prettyPrint] mutableCopy];
	[prettyPrint unionOrderedSet:self.combinator.prettyPrinted];
	return prettyPrint;
}

@end


id<HMRCombinator> HMRReduce(id<HMRCombinator> combinator, REDMapBlock block) {
	NSCParameterAssert(combinator != nil);
	NSCParameterAssert(block != nil);
	
	return [[HMRReduction alloc] initWithCombinator:combinator block:block];
}
