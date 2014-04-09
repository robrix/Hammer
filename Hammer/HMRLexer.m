//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLexer.h"
#import "HMRPair.h"
#import "HMRParsing.h"
#import <Reducers/REDReducer.h>

/*
 depth-first problem solving
 
 match a series of regular patterns like so:
 
 word = [A-Za-z]+ -> produce token
 whitespace = [ \s\t\n\r]+
 
 start = (word | whitespace)+
 
 while computing this, when we determine that we have produced a word, then perform its reduction
 */
l3_test("null reduction of partially parsed strings") {
	id<HMRCombinator> alternatives = HMRAlternate(HMRConcatenate(HMRLiteral(@"f"), HMRConcatenate(HMRLiteral(@"o"), HMRConcatenate(HMRLiteral(@"o"), HMRLiteral(@"t")))), HMRConcatenate(HMRLiteral(@"f"), HMRConcatenate(HMRLiteral(@"o"), HMRConcatenate(HMRLiteral(@"o"), HMRLiteral(@"d")))));
	id<HMRCombinator> derivative = [[[alternatives derivative:@"f"].compaction derivative:@"o"].compaction derivative:@"o"].compaction;
	
	id<HMRCombinator> expected = HMRAlternate(HMRConcatenate(HMRCaptureTree(@"f"), HMRConcatenate(HMRCaptureTree(@"o"), HMRConcatenate(HMRCaptureTree(@"o"), HMRLiteral(@"t")))), HMRConcatenate(HMRCaptureTree(@"f"), HMRConcatenate(HMRCaptureTree(@"o"), HMRConcatenate(HMRCaptureTree(@"o"), HMRLiteral(@"d"))))).compaction;
	
	l3_expect(derivative).to.equal(expected);
}


//id<REDReducible> HMRLexer(id<REDReducible> input) {
//	return [REDReducer reducerWithReducible:input transformer:^REDReducingBlock(REDReducingBlock reduce) {
//		return ^(id into, id each) {
//			grammar = [grammar derivative:each];
//			return reduce(into, each);
//		};
//	}];
//}

l3_test("lexer grammar") {
	NSMutableArray *reductions = [NSMutableArray new];
	id<HMRCombinator> wordSet = HMRCharacterSet([NSCharacterSet alphanumericCharacterSet]);
	id<HMRCombinator> word = [HMRReduce(HMRConcatenate(wordSet, HMRRepeat(wordSet)), ^id<NSObject,NSCopying>(id<NSObject,NSCopying> x) {
		[reductions addObject:x];
		return x;
	}) withName:@"word"];
	
	id<HMRCombinator> whitespaceSet = HMRCharacterSet([NSCharacterSet whitespaceAndNewlineCharacterSet]);
	id<HMRCombinator> whitespace = [HMRConcatenate(whitespaceSet, HMRRepeat(whitespaceSet)) withName:@"whitespace"];
	
	id<HMRCombinator> start = [HMRRepeat(HMRAlternate(word, whitespace)) withName:@"start"];
	
	__block id<HMRCombinator> grammar = start;
	
	
	
	NSSet *parseForest = [[@"word" red_reduce:grammar usingBlock:^id(id<HMRCombinator> into, id each) {
		printf("%s\n\n", HMRPrettyPrint(into).UTF8String);
		fflush(stdout);
		return [into derivative:each];
	}] parseForest];
	
	l3_expect(parseForest).to.equal([NSSet setWithObject:HMRList(@"w", @"o", @"r", @"d", nil)]);
	l3_expect(reductions).to.equal(@[ @[ @"w", @"o", @"r", @"d" ] ]);
	
//	[HMRLexer(@"ord") red_reduce:nil usingBlock:^(id into, id each) {
//		return into;
//	}];
}
