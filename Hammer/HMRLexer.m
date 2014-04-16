//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLexer.h"
#import "HMROperations.h"
#import "HMRPair.h"
#import "HMRParsing.h"
#import "HMRReduction.h"
#import <Reducers/REDReducer.h>

l3_test("lexer grammar") {
	NSMutableArray *reductions = [NSMutableArray new];
	id<HMRCombinator> wordSet = HMRContains([NSCharacterSet alphanumericCharacterSet]);
	id<HMRCombinator> word = [[(HMRReduction *)HMRMap(HMRAnd(wordSet, HMRRepeat(wordSet)), ^id<NSObject,NSCopying>(id<NSObject,NSCopying> x) {
		id reduced = [@"" red_append:(id)x];
		[reductions addObject:reduced];
		return reduced;
	}) withFunctionDescription:@"produce"] withName:@"word"];
	
	id<HMRCombinator> whitespaceSet = HMRContains([NSCharacterSet whitespaceAndNewlineCharacterSet]);
	id<HMRCombinator> whitespace = [[(HMRReduction *)HMRMap(HMRAnd(whitespaceSet, HMRRepeat(whitespaceSet)), ^(id _){ return [HMRPair null]; }) withFunctionDescription:@"ignore"] withName:@"whitespace"];
	
	id<HMRCombinator> period = [[(HMRReduction *)HMRMap(HMREqual(@"."), ^(id _) { return [HMRPair null]; }) withFunctionDescription:@"ignore"] withName:@"period"];
	
	__block id<HMRCombinator> start = [HMRAnd(HMROr(word, whitespace), HMROr(HMRCaptureTree([HMRPair null]), HMRDelay(start))) withName:@"start"];
	start = [HMRAnd(word, HMROr(HMRAnd(whitespace, HMRDelay(start)), period)) withName:@"start"];
	
	__block id<HMRCombinator> grammar = start;
	
	// S -> (word × ((whitespace × S) | '.'))
	// word -> ([[:alnum:]] × [[:alnum]]*)
	// whitespace -> ([[:space:]] × [[:space]]*)
	
	NSSet *parseForest = [[@"one fish." red_reduce:grammar usingBlock:^id(id<HMRCombinator> into, id each) {
		printf("\n%s\n", HMRPrettyPrint(into).UTF8String);
		fflush(stdout);
		return [into derivative:each];
	}] parseForest];
	
	l3_expect(parseForest).to.equal([NSSet setWithObject:@"word"]);
	l3_expect(reductions).to.equal(@[ @"word" ]);
	
//	[HMRLexer(@"ord") red_reduce:nil usingBlock:^(id into, id each) {
//		return into;
//	}];
}
