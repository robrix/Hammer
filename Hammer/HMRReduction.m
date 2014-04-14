//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRBlockCombinator.h"
#import "HMRConcatenation.h"
#import "HMRNull.h"
#import "HMRPair.h"
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

-(HMRReduction *)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return [(HMRReduction *)HMRMap([self.combinator derivative:object], self.block) withFunctionDescription:self.functionDescription];
}


-(NSSet *)reduceParseForest:(NSSet *)forest {
	return [[NSSet set] red_append:REDMap(forest, self.block)];
}

-(NSSet *)reduceParseForest {
	return [self reduceParseForest:self.combinator.parseForest];
}


static inline HMRReduction *HMRComposeReduction(HMRReduction *reduction, HMRReductionBlock g, NSString *functionDescription) {
	HMRReductionBlock f = reduction.block;
	NSString *description = [NSString stringWithFormat:@"%@∘%@", functionDescription ?: @"𝑔", reduction.functionDescription ?: @"𝑓"];
	return [(HMRReduction *)HMRMap(reduction.combinator, ^(id<NSObject, NSCopying> x) {
		id y = f(x);
		id z = g(y);
		return z;
	}) withFunctionDescription:description];
}

l3_addTestSubjectTypeWithFunction(HMRComposeReduction)
l3_test(&HMRComposeReduction) {
	NSString *a = @"a";
	HMRReductionBlock f = REDIdentityMapBlock;
	l3_expect(HMRComposeReduction(HMRMap(HMREqual(a), f), f, nil).description).to.equal(@"'a' → 𝑔∘𝑓");
}

-(id<HMRCombinator>)compact {
	id<HMRCombinator> combinator = self.combinator.compaction;
	id<HMRCombinator> compacted;
	if ([combinator isEqual:HMRNone()])
		compacted = HMRNone();
	else if ([combinator isKindOfClass:[HMRReduction class]])
		compacted = HMRComposeReduction(combinator, self.block, self.functionDescription);
	else if ([combinator isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)combinator).first isKindOfClass:[HMRNull class]]) {
		HMRConcatenation *concatenation = (HMRConcatenation *)combinator;
		HMRNull *first = (HMRNull *)concatenation.first;
		HMRReductionBlock block = self.block;
		compacted = [(HMRReduction *)HMRMap(concatenation.second, ^(id<NSObject,NSCopying> each) {
			return block(HMRCons(first.parseForest.anyObject, each));
		}) withFunctionDescription:[self.functionDescription stringByAppendingString:[NSString stringWithFormat:@"(%@ .)", first]]];
	}
	else if ([combinator isKindOfClass:[HMRNull class]])
		compacted = HMRCaptureForest([self reduceParseForest:combinator.parseForest]);
	else if (combinator == self.combinator)
		compacted = self;
	else
		compacted = [(HMRReduction *)HMRMap(combinator, self.block) withFunctionDescription:self.functionDescription];
	return compacted;
}

l3_test(@selector(compaction)) {
	HMRReduction *reduction = [(HMRReduction *)HMRMap(HMRAnd(HMRCaptureTree(@"a"), HMREqual(@"b")), ^(HMRPair *each) {
		return [[HMRPair null] red_append:REDMap(each, ^(NSString *each){
			return [each stringByAppendingString:each];
		})];
	}) withFunctionDescription:@"(map append .)"];
	l3_expect([reduction derivative:@"b"].parseForest).to.equal([NSSet setWithObject:HMRList(@"aa", @"bb", nil)]);
	l3_expect(reduction.compaction.description).to.equal(@"λ.'b' → (map append .)∘(ε↓{'a'} .)");
	
	reduction = HMRMap(HMRAnd(HMREqual(@"a"), HMRAnd(HMREqual(@"b"), HMREqual(@"c"))), REDIdentityMapBlock);
	l3_expect([[[reduction derivative:@"a"] derivative:@"b"] derivative:@"c"].parseForest).to.equal([NSSet setWithObject:HMRCons(@"a", HMRCons(@"b", @"c"))]);
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@ → %@", self.combinator.name ?: self.combinator.description, self.functionDescription ?: @"𝑓"];
}


-(NSUInteger)computeHash {
	return
		[super computeHash]
	^	self.combinator.hash;
}


-(id)reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return [self.combinator red_reduce:[super reduce:initial usingBlock:block] usingBlock:block];
}


-(instancetype)withFunctionDescription:(NSString *)functionDescription {
	_functionDescription = functionDescription;
	return self;
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRReduction *)object {
	return
		[object isKindOfClass:self.class]
	&&	[self.combinator isEqual:object.combinator]
	&&	[self.block isEqual:object.block];
}

@end


id<HMRCombinator> HMRMap(id<HMRCombinator> combinator, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>)) {
	NSCParameterAssert(combinator != nil);
	NSCParameterAssert(block != nil);
	
	return [[HMRReduction alloc] initWithCombinator:combinator block:block];
}

id<HMRPredicate> HMRReduced(id<HMRPredicate> combinator, id<HMRPredicate> block) {
	combinator = combinator ?: HMRAny();
	return [[HMRBlockCombinator alloc] initWithBlock:^bool (HMRReduction *subject) {
		return
			[subject isKindOfClass:[HMRReduction class]]
		&&	[combinator matchObject:subject.combinator]
		&&	[block matchObject:subject.block];
	}];
}
