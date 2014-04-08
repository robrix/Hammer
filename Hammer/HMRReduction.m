//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRConcatenation.h"
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
	return HMRReduce([self.combinator derivative:object], self.block);
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
	id<HMRCombinator> compacted;
	if ([combinator isKindOfClass:[HMRReduction class]])
		compacted = HMRComposeReduction(combinator, self.block);
	else if ([combinator isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)combinator).first isKindOfClass:[HMRNull class]]) {
		HMRConcatenation *concatenation = (HMRConcatenation *)combinator;
		HMRReductionBlock block = self.block;
		compacted = HMRReduce(concatenation.second, ^(id<NSObject,NSCopying> each) {
			return [[@[] red_append:REDFlattenMap(concatenation.first.parseForest, REDIdentityMapBlock)] red_append:(NSArray *)([each isKindOfClass:[NSArray class]]? block(each) : @[ block(each) ])];
		});
	}
	else if (combinator == self.combinator)
		compacted = self;
	else
		compacted = HMRReduce(combinator, self.block);
	return compacted;
}

l3_test(@selector(compaction)) {
	HMRReduction *reduction = HMRReduce(HMRConcatenate(HMRCaptureTree(@"x"), HMRLiteral(@"x")), REDIdentityMapBlock);
	id<HMRCombinator> expected = HMRLiteral(@"x");
	l3_expect(((HMRConcatenation *)reduction.combinator.compaction).second).to.equal(expected);
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


id<HMRCombinator> HMRReduce(id<HMRCombinator> combinator, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>)) {
	NSCParameterAssert(combinator != nil);
	NSCParameterAssert(block != nil);
	
	return [[HMRReduction alloc] initWithCombinator:combinator block:block];
}
