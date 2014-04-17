//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAnyCombinator.h"
#import "HMRMemoization.h"
#import "HMROperations.h"
#import <Hammer/Hammer.h>

NSUInteger HMRCombinatorSize(HMRCombinator *combinator) {
	NSNumber *size = [combinator red_reduce:@0 usingBlock:^(NSNumber *into, HMRCombinator *each) {
		return @(into.unsignedIntegerValue + 1);
	}];
	return size.unsignedIntegerValue;
}

l3_addTestSubjectTypeWithFunction(HMRCombinatorSize)
l3_test(&HMRCombinatorSize) {
	__block HMRCombinator *cyclic;
	HMRCombinator *cycle = HMRDelay(cyclic);
	cyclic = HMROr(HMROr(cycle, cycle), HMROr(cycle, cycle));
	l3_expect(HMRCombinatorSize(cyclic)).to.equal(@3);
}


NSString *HMRPrettyPrint(HMRCombinator *combinator) {
	return [@"" red_append:REDMap([combinator red_reduce:[NSMutableOrderedSet orderedSet] usingBlock:^(NSMutableOrderedSet *into, HMRCombinator *each) {
		if (each.name != nil) [into addObject:each.description];
		return into;
	}], ^(NSString *line) {
		return [line stringByAppendingString:@"\n"];
	})];
}

l3_addTestSubjectTypeWithFunction(HMRPrettyPrint)
l3_test(&HMRPrettyPrint) {
	HMRCombinator *terminal1 = [HMREqual(@"x") withName:@"x"];
	HMRCombinator *terminal2 = [HMREqual(@"y") withName:@"y"];
	__block HMRCombinator *nonterminal = [HMRAnd(terminal1, HMROr(terminal2, HMRDelay(nonterminal))) withName:@"S"];
	NSString *expected = [NSString stringWithFormat:@"%@\n%@\n%@\n", nonterminal.description, terminal1.description, terminal2.description];
	l3_expect(HMRPrettyPrint(nonterminal)).to.equal(expected);
}


bool HMRCombinatorIsCyclic(HMRCombinator *combinator) {
	NSMutableDictionary *cache = [NSMutableDictionary new];
	bool (^__weak __block recur)(HMRCombinator *);
	bool (^computeCyclic)(HMRCombinator *) = ^bool (HMRCombinator *combinator) {
		return [HMRMemoize(cache[combinator], @YES, HMRMatch(combinator, @[
			[HMRConcatenated(HMRBind(), HMRBind()) then:^(HMRCombinator *first, HMRCombinator *second) {
				return @(recur(first) || recur(second));
			}],
			[HMRAlternated(HMRBind(), HMRBind()) then:^(HMRCombinator *left, HMRCombinator *right) {
				return @(recur(left) || recur(right));
			}],
			[HMRReduced(HMRBind(), HMRAny()) then:^(HMRCombinator *combinator) {
				return @(recur(combinator));
			}],
			[HMRRepeated(HMRBind()) then:^(HMRCombinator *combinator) {
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
	l3_expect(HMRCombinatorIsCyclic(HMRAnd(HMREqual(@"x"), HMREqual(@"y")))).to.equal(@NO);
	l3_expect(HMRCombinatorIsCyclic(HMREqual(@"x"))).to.equal(@NO);
	
	__block HMRCombinator *cyclic = HMRAnd(HMREqual(@"x"), HMRDelay(cyclic));
	l3_expect(HMRCombinatorIsCyclic(cyclic)).to.equal(@YES);
}


bool HMRCombinatorIsNullable(HMRCombinator *combinator) {
	NSMutableDictionary *cache = [NSMutableDictionary new];
	bool (^__weak __block recur)(HMRCombinator *);
	bool (^isNullable)(HMRCombinator *) = ^bool (HMRCombinator *combinator) {
		return [HMRMemoize(cache[combinator], @NO, HMRMatch(combinator, @[
			[HMRConcatenated(HMRBind(), HMRBind()) then:^(HMRCombinator *first, HMRCombinator *second) {
				return @(recur(first) && recur(second));
			}],
			[HMRAlternated(HMRBind(), HMRBind()) then:^(HMRCombinator *left, HMRCombinator *right) {
				return @(recur(left) || recur(right));
			}],
			[HMRReduced(HMRBind(), HMRAny()) then:^(HMRCombinator *combinator) {
				return @(recur(combinator));
			}],
			[HMRRepeated(HMRAny()) then:^{ return @YES; }],
			[HMRCaptured(HMRAny()) then:^{ return @YES; }],
			[HMRKindOf([HMRAnyCombinator class]) then:^{ return @YES; }],
			[HMRAny() then:^{ return @NO; }]
		])) boolValue];
	};
	recur = isNullable;
	return isNullable(combinator);
}

l3_test(&HMRCombinatorIsNullable) {
	HMRCombinator *nonNullable = HMREqual(@"x");
	HMRCombinator *nullable = HMRRepeat(nonNullable);
	l3_expect(HMRCombinatorIsNullable(HMRAnd(nonNullable, nonNullable))).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable(HMRAnd(nonNullable, nullable))).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable(HMRAnd(nullable, nonNullable))).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable(HMRAnd(nullable, nullable))).to.equal(@YES);
	
	__block HMRCombinator *cyclic;
	l3_expect(HMRCombinatorIsNullable(cyclic = HMRAnd(HMRDelay(cyclic), nullable))).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable(cyclic = HMRAnd(nullable, HMRDelay(cyclic)))).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable(cyclic = HMRAnd(HMROr(nullable, HMRDelay(cyclic)), nullable))).to.equal(@YES);
	l3_expect(HMRCombinatorIsNullable(cyclic = HMRAnd(nullable, HMROr(nullable, HMRDelay(cyclic))))).to.equal(@YES);
	l3_expect(HMRCombinatorIsNullable(cyclic = HMRAnd(HMROr(nonNullable, HMRDelay(cyclic)), nullable))).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable(cyclic = HMRAnd(nullable, HMROr(nonNullable, HMRDelay(cyclic))))).to.equal(@NO);
	
	l3_expect(HMRCombinatorIsNullable(HMRMap(nullable, REDIdentityMapBlock))).to.equal(@YES);
	l3_expect(HMRCombinatorIsNullable(HMRMap(nonNullable, REDIdentityMapBlock))).to.equal(@NO);
}
