//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLexer.h"
#import "HMROperations.h"
#import "HMRPair.h"
#import "HMRParsing.h"
#import "HMRReduction.h"
#import <Reducers/REDReducer.h>

id<REDReducible> HMRLex(id<REDReducible> input, id<REDReducible> patterns) {
	HMRCombinator *lexer = [HMRCombinator alternate:patterns];
	__block NSSet *parseForest = [NSSet set];
	
	return [[input red_reduce:[lexer withName:@"S"] usingBlock:^(HMRCombinator *into, id each) {
		HMRCombinator *derivative = [into derivative:each];
		
		if ([derivative isEqual:[HMRCombinator empty]]) {
			if (into.parseForest.count) parseForest = into.parseForest;
			derivative = [[[[HMRCombinator capture:parseForest] concat:lexer] withName:@"S"] derivative:each];
		}
		return derivative;
	}] parseForest];
	
	return parseForest;
}

l3_test("lexer grammar") {
	NSMutableCharacterSet *first = [NSMutableCharacterSet letterCharacterSet];
	[first addCharactersInString:@"_-"];
	NSMutableCharacterSet *rest = [NSMutableCharacterSet alphanumericCharacterSet];
	[rest addCharactersInString:@"_-"];
	
	HMRCombinator *symbol = [[[[[[HMRCombinator containedIn:first] withName:@"first"] concat:[[[HMRCombinator containedIn:rest] withName:@"rest"] repeat]] map:^(id<REDReducible> each) {
		return [@"" red_append:each];
	}] withFunctionDescription:@"stringify"] withName:@"symbol"];
	
	HMRCombinator *whitespaceSet = [HMRCombinator containedIn:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	HMRCombinator *whitespace = [[[whitespaceSet concat:[whitespaceSet repeat]] ignore] withName:@"whitespace"];
	
	NSString *input = @"colourless green ideas sleep furiously";
	NSSet *lexed = (NSSet *)HMRLex(input, @[ symbol, whitespace ]);
	
	l3_expect(lexed).to.equal([NSSet setWithObject:HMRCons(HMRCons(HMRCons(HMRCons(@"colourless", @"green"), @"ideas"), @"sleep"), @"furiously")]);
}

l3_test("lexer incrementality") {
	NSMutableArray *reductions = [NSMutableArray new];
	HMRCombinator *wordSet = [HMRCombinator containedIn:[NSCharacterSet alphanumericCharacterSet]];
	HMRCombinator *word = [[[[wordSet concat:[wordSet repeat]] map:^id<NSObject,NSCopying>(id<NSObject,NSCopying> x) {
		id reduced = [@"" red_append:(id)x];
		[reductions addObject:reduced];
		return reduced;
	}] withFunctionDescription:@"produce"] withName:@"word"];
	
	HMRCombinator *whitespaceSet = [HMRCombinator containedIn:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	HMRCombinator *whitespace = [[[whitespaceSet concat:[whitespaceSet repeat]] ignore] withName:@"whitespace"];
	
	HMRCombinator *period = [[[[HMRCombinator literal:@"."] mapSet:^(id all) { return [NSSet setWithObject:[HMRPair null]]; }] withFunctionDescription:@"terminate"] withName:@"period"];
	
	__block HMRCombinator *start = [[word concat:[[whitespace concat:HMRDelay(start)] or:period]] withName:@"start"];
	
	__block HMRCombinator *grammar = start;
	
	HMRCombinator *parsed = [@"one fish two fish red fish blue fish." red_reduce:grammar usingBlock:^(HMRCombinator *into, id each) {
		return [into derivative:each];
	}];
	NSSet *parseForest = [parsed parseForest];
	
	l3_expect(parseForest).to.equal([NSSet setWithObject:HMRList(@"one", @"fish", @"two", @"fish", @"red", @"fish", @"blue", @"fish", nil)]);
	l3_expect(reductions).to.equal(@[ @"one", @"fish", @"two", @"fish", @"red", @"fish", @"blue", @"fish" ]);
}
