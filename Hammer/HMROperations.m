//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
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
	NSNumber *cyclic = [combinator red_reduce:@YES usingBlock:^(NSNumber *into, id<HMRCombinator> each) {
		return [HMRCase match:each withCases:@[
			[HMRCase case:HMRConcatenationPredicate(HMRBind, HMRBind) then:^(id<HMRCombinator> first, id<HMRCombinator> second) {
				return @(HMRCombinatorIsCyclic(first) || HMRCombinatorIsCyclic(second));
			}],
			[HMRCase case:REDTruePredicateBlock then:^{ return @NO; }],
		]];
	}];
	return cyclic.boolValue;
}

l3_addTestSubjectTypeWithFunction(HMRCombinatorIsCyclic)
l3_test(&HMRCombinatorIsCyclic) {
	l3_expect(HMRCombinatorIsCyclic(HMRConcatenate(HMRLiteral(@"x"), HMRLiteral(@"y")))).to.equal(@NO);
	l3_expect(HMRCombinatorIsCyclic(HMRLiteral(@"x"))).to.equal(@NO);
}
