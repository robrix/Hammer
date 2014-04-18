//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLexer.h"
#import "HMROperations.h"
#import "HMRPair.h"
#import "HMRParsing.h"
#import "HMRReduction.h"
#import <Reducers/REDReducer.h>

l3_test("lexer grammar") {
	NSMutableArray *reductions = [NSMutableArray new];
	HMRCombinator *wordSet = [HMRCombinator containedIn:[NSCharacterSet alphanumericCharacterSet]];
	HMRCombinator *word = [[[[wordSet and:[wordSet repeat]] map:^id<NSObject,NSCopying>(id<NSObject,NSCopying> x) {
		id reduced = [@"" red_append:(id)x];
		[reductions addObject:reduced];
		return reduced;
	}] withFunctionDescription:@"produce"] withName:@"word"];
	
	HMRReductionBlock ignore = ^(id<REDReducible> all) { return [NSSet set]; };
	
	HMRCombinator *whitespaceSet = [HMRCombinator containedIn:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	HMRCombinator *whitespace = [[[[whitespaceSet and:[whitespaceSet repeat]] mapSet:ignore] withFunctionDescription:@"ignore"] withName:@"whitespace"];
	
	HMRCombinator *period = [[[[HMRCombinator literal:@"."] mapSet:^(id all) { return [NSSet setWithObject:[HMRPair null]]; }] withFunctionDescription:@"ignore"] withName:@"period"];
	
	__block HMRCombinator *start = [[word and:[[whitespace and:HMRDelay(start)] or:period]] withName:@"start"];
	
	__block HMRCombinator *grammar = start;
	
	HMRCombinator *parsed = [@"one fish two fish red fish blue fish." red_reduce:grammar usingBlock:^(HMRCombinator *into, id each) {
		return [into derivative:each];
	}];
	NSSet *parseForest = [parsed parseForest];
	
	l3_expect(parseForest).to.equal([NSSet setWithObject:HMRList(@"one", @"fish", @"two", @"fish", @"red", @"fish", @"blue", @"fish", nil)]);
	l3_expect(reductions).to.equal(@[ @"one", @"fish", @"two", @"fish", @"red", @"fish", @"blue", @"fish" ]);
}
