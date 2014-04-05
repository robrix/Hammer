//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParsing.h"

NSSet *HMRParseCollection(id<HMRCombinator> parser, id<REDReducible> reducible) {
	parser = [reducible red_reduce:parser usingBlock:^(id<HMRCombinator> parser, id each) {
		return [parser derivative:each];
	}];
	return parser.parseForest;
}

l3_addTestSubjectTypeWithFunction(HMRParseCollection);
l3_test(&HMRParseCollection) {
	id object = @0;
	id<HMRCombinator> literal = HMRLiteral(object);
	l3_expect(HMRParseCollection(literal, @[ object ])).to.equal([NSSet setWithObject:object]);
	l3_expect(HMRParseCollection(literal, @[])).to.equal([NSSet set]);
	id anythingElse = @1;
	l3_expect(HMRParseCollection(literal, @[ anythingElse ])).to.equal([NSSet set]);
	
	l3_expect(HMRParseCollection(HMRConcatenate(literal, literal), @[ object, object ])).to.equal([NSSet setWithObject:@[object, object]]);
	
	id terminal = @"x";
	id nonterminalPrefix = @"+";
	// S -> "+" S | "x"
	__block id<HMRCombinator> nonterminal;
	nonterminal = HMRReduce(HMRAlternate(HMRConcatenate(HMRLiteral(nonterminalPrefix), HMRDelay(nonterminal)), HMRLiteral(terminal)), ^(id each) { return @[ each ]; });
	l3_expect(HMRParseCollection(nonterminal, @[ terminal ])).to.equal([NSSet setWithObject:@[ terminal ]]);
	l3_expect(HMRParseCollection(nonterminal, @[ nonterminalPrefix, terminal ])).to.equal([NSSet setWithObject:@[ @[ nonterminalPrefix, terminal ] ]]);
	id nested = [NSSet setWithObject:@[ @[ nonterminalPrefix, @[ nonterminalPrefix, terminal ] ] ]];
	l3_expect(HMRParseCollection(nonterminal, @[ nonterminalPrefix, nonterminalPrefix, terminal ])).to.equal(nested);
}


id<HMRCombinator> HMRParseObject(id<HMRCombinator> parser, id<NSObject, NSCopying> object) {
	return object?
	[parser derivative:object]
	:	nil; // ???
}
