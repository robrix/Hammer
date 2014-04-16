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
	
	HMRReductionBlock ignore = ^(id _) { return [HMRPair null]; };
	
	id<HMRCombinator> whitespaceSet = HMRContains([NSCharacterSet whitespaceAndNewlineCharacterSet]);
	id<HMRCombinator> whitespace = [[(HMRReduction *)HMRMap(HMRAnd(whitespaceSet, HMRRepeat(whitespaceSet)), ignore) withFunctionDescription:@"ignore"] withName:@"whitespace"];
	
	id<HMRCombinator> period = [[(HMRReduction *)HMRMap(HMREqual(@"."), ignore) withFunctionDescription:@"ignore"] withName:@"period"];
	
	__block id<HMRCombinator> start = [HMRAnd(word, HMROr(HMRAnd(whitespace, HMRDelay(start)), period)) withName:@"start"];
	
	__block id<HMRCombinator> grammar = start;
	
	NSSet *parseForest = [[@"one fish two fish red fish blue fish." red_reduce:grammar usingBlock:^id(id<HMRCombinator> into, id each) {
		printf("\n%s\n", HMRPrettyPrint(into).UTF8String);
		fflush(stdout);
		return [into derivative:each];
	}] parseForest];
	
	l3_expect(parseForest).to.equal([NSSet setWithObject:HMRList(@"one", @"fish", @"two", @"fish", @"red", @"fish", @"blue", @"fish", nil)]);
	l3_expect(reductions).to.equal(@[ @"one", @"fish", @"two", @"fish", @"red", @"fish", @"blue", @"fish" ]);
}
