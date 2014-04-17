//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRPair.h"
#import "HMRParsing.h"

NSSet *HMRParseCollection(HMRCombinator *parser, id<REDReducible> reducible) {
	parser = [reducible red_reduce:parser usingBlock:^(HMRCombinator *parser, id each) {
		return [parser derivative:each];
	}];
	return parser.parseForest;
}

l3_addTestSubjectTypeWithFunction(HMRParseCollection);
l3_test(&HMRParseCollection) {
	id object = @0;
	HMRCombinator *literal = HMREqual(object);
	l3_expect(HMRParseCollection(literal, @[ object ])).to.equal([NSSet setWithObject:object]);
	l3_expect(HMRParseCollection(literal, @[])).to.equal([NSSet set]);
	id anythingElse = @1;
	l3_expect(HMRParseCollection(literal, @[ anythingElse ])).to.equal([NSSet set]);
	
	l3_expect(HMRParseCollection([literal and:literal], @[ object, object ])).to.equal([NSSet setWithObject:HMRCons(object, object)]);
	
	id terminal = @"x";
	id nonterminalPrefix = @"+";
	// S -> "+" S | "x"
	__block HMRCombinator *nonterminal;
	nonterminal = [HMRMap(HMROr(HMRAnd([HMREqual(nonterminalPrefix) withName:@"prefix"], HMRDelay(nonterminal)), [HMREqual(terminal) withName:@"final"]), ^(id each) { return HMRList(each, nil); }) withName:@"S"];
	l3_expect(HMRParseCollection(nonterminal, @[ terminal ])).to.equal([NSSet setWithObject:HMRList(terminal, nil)]);
	l3_expect(HMRParseCollection(nonterminal, @[ nonterminalPrefix, terminal ])).to.equal([NSSet setWithObject:HMRList(HMRList(nonterminalPrefix, terminal, nil), nil)]);
	id nested = [NSSet setWithObject:HMRList(HMRList(nonterminalPrefix, HMRList(nonterminalPrefix, terminal, nil), nil), nil)];
	l3_expect(HMRParseCollection(nonterminal, @[ nonterminalPrefix, nonterminalPrefix, terminal ])).to.equal(nested);
}


HMRCombinator *HMRParseObject(HMRCombinator *parser, id<NSObject, NSCopying> object) {
	return object?
		[parser derivative:object]
	:	nil; // ???
}
