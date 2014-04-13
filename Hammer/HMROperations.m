//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRMemoization.h"
#import "HMROperations.h"

NSUInteger HMRCombinatorSize(id<HMRCombinator> combinator) {
	NSNumber *size = [combinator red_reduce:@0 usingBlock:^(NSNumber *into, id<HMRCombinator> each) {
		return @(into.unsignedIntegerValue + 1);
	}];
	return size.unsignedIntegerValue;
}

l3_addTestSubjectTypeWithFunction(HMRCombinatorSize)
l3_test(&HMRCombinatorSize) {
	__block id<HMRCombinator> cyclic;
	id<HMRCombinator>cycle = HMRDelay(cyclic);
	cyclic = HMRAlternate(HMRAlternate(cycle, cycle), HMRAlternate(cycle, cycle));
	l3_expect(HMRCombinatorSize(cyclic)).to.equal(@3);
}


NSString *HMRPrettyPrint(id<HMRCombinator> combinator) {
	return [@"" red_append:REDMap([combinator red_reduce:[NSMutableOrderedSet orderedSet] usingBlock:^(NSMutableOrderedSet *into, id<HMRCombinator> each) {
		if (each.name != nil) [into addObject:each.description];
		return into;
	}], ^(NSString *line) {
		return [line stringByAppendingString:@"\n"];
	})];
}

l3_addTestSubjectTypeWithFunction(HMRPrettyPrint)
l3_test(&HMRPrettyPrint) {
	id<HMRCombinator> terminal1 = [HMRLiteral(@"x") withName:@"x"];
	id<HMRCombinator> terminal2 = [HMRLiteral(@"y") withName:@"y"];
	__block id<HMRCombinator> nonterminal = [HMRConcatenate(terminal1, HMRAlternate(terminal2, HMRDelay(nonterminal))) withName:@"S"];
	NSString *expected = [NSString stringWithFormat:@"%@\n%@\n%@\n", nonterminal.description, terminal1.description, terminal2.description];
	l3_expect(HMRPrettyPrint(nonterminal)).to.equal(expected);
}


bool HMRCombinatorIsCyclic(id<HMRCombinator> combinator) {
	NSMutableDictionary *cache = [NSMutableDictionary new];
	bool (^__weak __block recur)(id<HMRCombinator>);
	bool (^computeCyclic)(id<HMRCombinator>) = ^bool (id<HMRCombinator> combinator) {
		return [HMRMemoize(cache[combinator], @YES, HMRMatch(combinator, @[
			[HMRConcatenate(HMRBind(), HMRBind()) then:^(id<HMRCombinator> first, id<HMRCombinator> second) {
				return @(recur(first) || recur(second));
			}],
			[HMRAlternate(HMRBind(), HMRBind()) then:^(id<HMRCombinator> left, id<HMRCombinator> right) {
				return @(recur(left) || recur(right));
			}],
			[HMRReduce(HMRBind(), HMRBind()) then:^(id<HMRCombinator> combinator, HMRReductionBlock f) {
				return @(recur(combinator));
			}],
			[HMRRepeat(HMRBind()) then:^(id<HMRCombinator> combinator) {
				return @(recur(combinator));
			}],
			[HMRAny() then:^{ return @NO; }],
		])) boolValue];
	};
	recur = computeCyclic;
	return computeCyclic(combinator);
}

l3_addTestSubjectTypeWithFunction(HMRCombinatorIsCyclic)
l3_test(&HMRCombinatorIsCyclic) {
	l3_expect(HMRCombinatorIsCyclic(HMRConcatenate(HMRLiteral(@"x"), HMRLiteral(@"y")))).to.equal(@NO);
	l3_expect(HMRCombinatorIsCyclic(HMRLiteral(@"x"))).to.equal(@NO);
	
	__block id<HMRCombinator> cyclic = HMRConcatenate(HMRLiteral(@"x"), HMRDelay(cyclic));
	l3_expect(HMRCombinatorIsCyclic(cyclic)).to.equal(@YES);
}
