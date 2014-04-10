//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRConcatenation.h"
#import "HMRNull.h"
#import "HMRPair.h"
#import "HMRReduction.h"

@implementation HMRReduction

-(instancetype)initWithCombinator:(id<HMRCombinator>)combinator block:(HMRReductionBlock)block {
	if ((self = [super init])) {
		_combinator = [combinator copyWithZone:NULL];
		_block = [block copy];
		
		_functionDescription = @"𝑓";
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


-(NSSet *)reduceParseForest:(NSSet *)forest {
	return [[NSSet set] red_append:REDMap(forest, ^(id<NSObject,NSCopying> tree) {
		return self.block(tree);
	})];
}

-(NSSet *)reduceParseForest {
	return [self reduceParseForest:self.combinator.parseForest];
}


static inline HMRReduction *HMRComposeReduction(HMRReduction *reduction, HMRReductionBlock g) {
	HMRReductionBlock f = reduction.block;
	return [(HMRReduction *)HMRReduce(reduction.combinator, ^(id<NSObject, NSCopying> x) { return g(f(x)); }) withFunctionDescription:[@"𝑔∘" stringByAppendingString:reduction.functionDescription]];
}

l3_addTestSubjectTypeWithFunction(HMRComposeReduction)
l3_test(&HMRComposeReduction) {
	NSString *a = @"a";
	HMRReductionBlock f = REDIdentityMapBlock;
	l3_expect(HMRComposeReduction(HMRReduce(HMRLiteral(a), f), f).description).to.equal(@"'a' → 𝑔∘𝑓");
}

-(id<HMRCombinator>)compact {
	id<HMRCombinator> combinator = self.combinator.compaction;
	id<HMRCombinator> compacted;
	if ([combinator isKindOfClass:[HMRReduction class]])
		compacted = HMRComposeReduction(combinator, self.block);
	else if ([combinator isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)combinator).first isKindOfClass:[HMRNull class]]) {
		HMRConcatenation *concatenation = (HMRConcatenation *)combinator;
		HMRNull *first = concatenation.first;
		HMRReductionBlock block = self.block;
		compacted = HMRReduce(concatenation.second, ^(id<NSObject,NSCopying> each) {
			return block(HMRCons(first.parseForest.anyObject, each));
		});
	}
	else if ([combinator isKindOfClass:[HMRNull class]])
		compacted = HMRCaptureForest([self reduceParseForest:combinator.parseForest]);
	else if (combinator == self.combinator)
		compacted = self;
	else
		compacted = HMRReduce(combinator, self.block);
	return compacted;
}

l3_test(@selector(compaction)) {
	HMRReduction *reduction = HMRReduce(HMRConcatenate(HMRCaptureTree(@"a"), HMRLiteral(@"b")), ^(HMRPair *each) {
		return [[HMRPair null] red_append:REDMap(each, ^(NSString *each){
			return [each stringByAppendingString:each];
		})];
	});
	l3_expect([reduction derivative:@"b"].parseForest).to.equal([NSSet setWithObject:HMRList(@"aa", @"bb", nil)]);
	
	reduction = HMRReduce(HMRConcatenate(HMRLiteral(@"a"), HMRConcatenate(HMRLiteral(@"b"), HMRLiteral(@"c"))), REDIdentityMapBlock);
	l3_expect([[[reduction derivative:@"a"] derivative:@"b"] derivative:@"c"].parseForest).to.equal([NSSet setWithObject:HMRCons(@"a", HMRCons(@"b", @"c"))]);
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@ → %@", self.combinator.name ?: self.combinator.description, self.functionDescription];
}

-(NSOrderedSet *)prettyPrint {
	NSMutableOrderedSet *prettyPrint = [[super prettyPrint] mutableCopy];
	[prettyPrint unionOrderedSet:self.combinator.prettyPrinted];
	return prettyPrint;
}


-(instancetype)withFunctionDescription:(NSString *)functionDescription {
	_functionDescription = functionDescription;
	return self;
}

@end


id<HMRCombinator> HMRReduce(id<HMRCombinator> combinator, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>)) {
	NSCParameterAssert(combinator != nil);
	NSCParameterAssert(block != nil);
	
	return [[HMRReduction alloc] initWithCombinator:combinator block:block];
}
