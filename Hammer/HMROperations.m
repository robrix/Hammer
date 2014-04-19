//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAnyCombinator.h"
#import "HMRDelay.h"
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
	cyclic = [[cycle or:cycle] or:[cycle or:cycle]];
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
	HMRCombinator *terminal1 = [[HMRCombinator literal:@"x"] withName:@"x"];
	HMRCombinator *terminal2 = [[HMRCombinator literal:@"y"] withName:@"y"];
	__block HMRCombinator *nonterminal = [[terminal1 concat:[terminal2 or:HMRDelay(nonterminal)]] withName:@"S"];
	NSString *expected = [NSString stringWithFormat:@"%@\n%@\n%@\n", nonterminal.description, terminal1.description, terminal2.description];
	l3_expect(HMRPrettyPrint(nonterminal)).to.equal(expected);
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
			[[HMRKindOf kindOfClass:[HMRAnyCombinator class]] then:^{ return @YES; }],
			[HMRAny() then:^{ return @NO; }]
		])) boolValue];
	};
	recur = isNullable;
	return isNullable(combinator);
}

l3_addTestSubjectTypeWithFunction(HMRCombinatorIsNullable)
l3_test(&HMRCombinatorIsNullable) {
	HMRCombinator *nonNullable = [HMRCombinator literal:@"x"];
	HMRCombinator *nullable = [nonNullable repeat];
	l3_expect(HMRCombinatorIsNullable([nonNullable concat:nonNullable])).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable([nonNullable concat:nullable])).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable([nullable concat:nonNullable])).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable([nullable concat:nullable])).to.equal(@YES);
	
	__block HMRCombinator *cyclic;
	l3_expect(HMRCombinatorIsNullable(cyclic = [HMRDelay(cyclic) concat:nullable])).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable(cyclic = [nullable concat:HMRDelay(cyclic)])).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable(cyclic = [[nullable or:HMRDelay(cyclic)] concat:nullable])).to.equal(@YES);
	l3_expect(HMRCombinatorIsNullable(cyclic = [nullable concat:[nullable or:HMRDelay(cyclic)]])).to.equal(@YES);
	l3_expect(HMRCombinatorIsNullable(cyclic = [[nonNullable or:HMRDelay(cyclic)] concat:nullable])).to.equal(@NO);
	l3_expect(HMRCombinatorIsNullable(cyclic = [nullable concat:[nonNullable or:HMRDelay(cyclic)]])).to.equal(@NO);
	
	l3_expect(HMRCombinatorIsNullable([nullable map:REDIdentityMapBlock])).to.equal(@YES);
	l3_expect(HMRCombinatorIsNullable([nonNullable map:REDIdentityMapBlock])).to.equal(@NO);
}
