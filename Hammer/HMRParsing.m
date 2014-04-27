//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRContainment.h"
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
	HMRCombinator *literal = [HMRCombinator literal:object];
	l3_expect(HMRParseCollection(literal, @[ object ])).to.equal([NSSet setWithObject:object]);
	l3_expect(HMRParseCollection(literal, @[])).to.equal([NSSet set]);
	id anythingElse = @1;
	l3_expect(HMRParseCollection(literal, @[ anythingElse ])).to.equal([NSSet set]);
	
	l3_expect(HMRParseCollection([literal concat:literal], @[ object, object ])).to.equal([NSSet setWithObject:HMRCons(object, object)]);
	
	id terminal = @"x";
	id nonterminalPrefix = @"+";
	// S -> "+" S | "x"
	__block HMRCombinator *nonterminal;
	nonterminal = [[[[[[HMRCombinator literal:nonterminalPrefix] withName:@"prefix"] concat:HMRDelay(nonterminal)] or:[[HMRCombinator literal:terminal] withName:@"final"]] map:^(id each) {
		return HMRList(each, nil);
	}] withName:@"S"];
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


HMRCombinator *HMRParser(void) {
	HMRCombinator *backslash = [HMRCombinator literal:@"\\"];
	HMRCombinator *openBracket = [HMRCombinator literal:@"["];
	HMRCombinator *closeBracket = [HMRCombinator literal:@"]"];
	HMRCombinator *quote = [HMRCombinator literal:@"'"];
	
	HMRCombinator *alphanumeric = [HMRCombinator containedIn:[HMRContainment characterSetsByName][HMRAlphanumericCharacterSetName]];
	
	HMRCombinator *symbol = [HMRCombinator concatenate:@[
		[alphanumeric or:[HMRCombinator containedIn:[NSCharacterSet characterSetWithCharactersInString:@"_"]]],
		[[alphanumeric or:[HMRCombinator containedIn:[NSCharacterSet characterSetWithCharactersInString:@"_-"]]] repeat],
	]];
	
	HMRCombinator *ws = [[[[HMRCombinator containedIn:[HMRContainment characterSetsByName][HMRWhitespaceCharacterSetName]] repeat] ignore] withName:@"ws"];
	HMRCombinator *wsnl = [[[[HMRCombinator containedIn:[HMRContainment characterSetsByName][HMRWhitespaceAndNewlineCharacterSetName]] repeat] ignore] withName:@"wsnl"];
	HMRCombinator *newlineCharacter = [HMRCombinator containedIn:[NSCharacterSet newlineCharacterSet]];
	HMRCombinator *nl = [[[newlineCharacter concat:[newlineCharacter repeat]] ignore] withName:@"nl"];
	
	HMRCombinator *any = [[HMRCombinator literal:@"."] withName:@"any"];
	HMRCombinator *escapedCharacter = [[HMRCombinator alternate:@[ backslash, [HMRCombinator literal:@"n"], [HMRCombinator literal:@"r"], [HMRCombinator literal:@"t"], ]] withName:@"escaped-character"];
	
	HMRCombinator *POSIXCharacterClasses = [HMRCombinator concatenate:@[
		openBracket,
		[HMRCombinator literal:@":"],
		[HMRCombinator alternate:REDMap([HMRContainment characterSetsByName], ^(NSString *name) { return [HMRCombinator literal:name]; })],
		[HMRCombinator literal:@":"],
		closeBracket,
	]];
	
	HMRCombinator *characterSetCharacter = [[HMRCombinator alternate:@[
		POSIXCharacterClasses,
		[backslash concat:[escapedCharacter or:closeBracket]],
		[HMRCombinator containedIn:[[NSCharacterSet characterSetWithCharactersInString:@"]"] invertedSet]],
	]] withName:@"character-set-character"];
	
	HMRCombinator *characterSet = [[HMRCombinator concatenate:@[
		openBracket,
		[[HMRCombinator literal:@"^"] optional],
		characterSetCharacter,
		[characterSetCharacter repeat],
		closeBracket,
	]] withName:@"character-set"];
	
	HMRCombinator *literalCharacter = [[HMRCombinator alternate:@[
		[backslash concat:[escapedCharacter or:quote]],
		[HMRCombinator containedIn:[[NSCharacterSet characterSetWithCharactersInString:@"'"] invertedSet]],
	]] withName:@"literal-character"];
	
	HMRCombinator *literal = [[HMRCombinator concatenate:@[ quote, literalCharacter, quote, ]] withName:@"literal"];
	
	HMRCombinator *terminal = [[HMRCombinator alternate:@[ literal, characterSet, any ]] withName:@"terminal"];
	
	__block HMRCombinator *nonterminal;
	
	HMRCombinator *parenthesized = [HMRCombinator concatenate:@[ [HMRCombinator literal:@"("], wsnl, HMRDelay(nonterminal), wsnl, [HMRCombinator literal:@")"], ]];
	
	HMRCombinator *repetition = [[HMRCombinator concatenate:@[
		[HMRCombinator alternate:@[ symbol, terminal, parenthesized ]],
		wsnl,
		[[HMRCombinator literal:@"*"] optional],
	]] withName:@"repetition"];
	
	HMRCombinator *concatenation = [[HMRCombinator concatenate:@[ repetition, [[wsnl concat:repetition] repeat] ]] withName:@"concatenation"];
	
	HMRCombinator *alternation = [[HMRCombinator concatenate:@[
		concatenation,
		[[HMRCombinator concatenate:@[ wsnl, [HMRCombinator literal:@"|"], wsnl, concatenation ]] repeat],
	]] withName:@"alternation"];
	
	nonterminal = alternation;
	
	HMRCombinator *production = [[HMRCombinator concatenate:@[
		ws,
		symbol,
		wsnl,
		[[[HMRCombinator literal:@"-"] concat:[HMRCombinator literal:@">"]] ignore],
		wsnl,
		nonterminal,
		ws,
	]] withName:@"production"];
	
	HMRCombinator *grammar = [[[HMRCombinator concatenate:@[
		production,
		[[nl concat:production] repeat],
	]] optional] withName:@"grammar"];
	
	return grammar;
}
