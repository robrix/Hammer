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
	
	HMRCombinator *alphanumeric = [HMRContainment characterSetsByName][HMRAlphanumericCharacterSetName];
	
	HMRCombinator *symbol = [HMRCombinator concatenate:@[
		[alphanumeric or:[HMRCombinator containedIn:[NSCharacterSet characterSetWithCharactersInString:@"_"]]],
		[[alphanumeric or:[HMRCombinator containedIn:[NSCharacterSet characterSetWithCharactersInString:@"_-"]]] repeat],
	]];
	
	HMRCombinator *ws = [[HMRContainment characterSetsByName][HMRWhitespaceCharacterSetName] repeat];
	HMRCombinator *wsnl = [[HMRContainment characterSetsByName][HMRWhitespaceAndNewlineCharacterSetName] repeat];
	HMRCombinator *nl = [HMRCombinator containedIn:[NSCharacterSet newlineCharacterSet]];
	
	HMRCombinator *any = [HMRCombinator literal:@"."];
	HMRCombinator *escapedCharacter = [HMRCombinator alternate:@[ backslash, [HMRCombinator literal:@"n"], [HMRCombinator literal:@"r"], [HMRCombinator literal:@"t"], ]];
	
	HMRCombinator *POSIXCharacterClasses = [HMRCombinator concatenate:@[
		openBracket,
		[HMRCombinator literal:@":"],
		[HMRCombinator alternate:REDMap([HMRContainment characterSetsByName], ^(NSString *name) { return [HMRCombinator literal:name]; })],
		[HMRCombinator literal:@":"],
		closeBracket,
	]];
	
	HMRCombinator *characterSetCharacter = [HMRCombinator alternate:@[
		POSIXCharacterClasses,
		[backslash concat:[escapedCharacter or:closeBracket]],
		[HMRCombinator containedIn:[[NSCharacterSet characterSetWithCharactersInString:@"]"] invertedSet]],
	]];
	
	HMRCombinator *characterSet = [HMRCombinator concatenate:@[
		openBracket,
		[[HMRCombinator literal:@"^"] optional],
		characterSetCharacter,
		[characterSetCharacter repeat],
		closeBracket,
	]];
	
	HMRCombinator *literalCharacter = [HMRCombinator alternate:@[
		[backslash concat:[escapedCharacter or:quote]],
		[HMRCombinator containedIn:[[NSCharacterSet characterSetWithCharactersInString:@"'"] invertedSet]],
	]];
	
	HMRCombinator *literal = [HMRCombinator concatenate:@[ quote, literalCharacter, quote, ]];
	
	HMRCombinator *terminal = [HMRCombinator alternate:@[ literal, characterSet, any ]];
	
	return nil;
}
