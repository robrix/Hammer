//  HammerParserParseNullFunctionTests.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerParserParseNullFunction.h"
#import <Hammer/Hammer.h>

@interface HammerParserParseNullFunctionTests : SenTestCase
@end

@implementation HammerParserParseNullFunctionTests

-(void)testEmptyParsersProduceTheEmptySet {
	STAssertEqualObjects([HammerParserParseNullFunction parseNull:[HammerEmptyParser parser]], [NSSet set], @"Expected equals.");
}

-(void)testNullParsersProduceTheEmptyString {
	STAssertEqualObjects([HammerParserParseNullFunction parseNull:[HammerNullParser parser]], [NSSet setWithObject:@""], @"Expected equals.");
}

-(void)testNullReductionParsersProduceTheirParseTrees {
	STAssertEqualObjects([HammerParserParseNullFunction parseNull:[HammerNullReductionParser parserWithParseTrees:([NSSet setWithObjects:@"a", @"b", nil])]], ([NSSet setWithObjects:@"a", @"b", nil]), @"Expected equals.");
}


-(void)testTermParsersProduceTheEmptySet {
	STAssertEqualObjects([HammerParserParseNullFunction parseNull:[HammerTermParser parserWithTerm:@"a"]], [NSSet set], @"Expected equals.");
}


-(void)testAlternationParsersProduceTheUnionOfTheirChildParseForests {
	STAssertEqualObjects([HammerParserParseNullFunction parseNull:[HammerAlternationParser parserWithLeft:HammerDelay([HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"b"]]) right:HammerDelay([HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]])]], ([NSSet setWithObjects:@"a", @"b", nil]), @"Expected equals.");
}

-(void)testConcatenationParsersProduceSequencesOfTheirChildParseForests {
	STAssertEqualObjects([HammerParserParseNullFunction parseNull:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"b"]]) second:HammerDelay([HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]])]], ([NSSet setWithObject:@[@"b", @"a"]]), @"Expected equals.");
}

-(void)testReductionParsersProduceParseTreesReducedByTheirFunctions {
	STAssertEqualObjects([HammerParserParseNullFunction parseNull:[HammerReductionParser parserWithParser:HammerDelay([HammerNullReductionParser parserWithParseTrees:([NSSet setWithObjects:@"a", @"b", nil])]) function:^(NSString *tree) {
		return [tree stringByAppendingString:tree];
	}]], ([NSSet setWithObjects:@"aa", @"bb", nil]), @"Expected equals.");
}


-(void)testRecursiveAlternationParsersProduceTheirChildParseForests {
	__block HammerParser *parser = [HammerAlternationParser parserWithLeft:HammerDelay(parser) right:HammerDelay([HammerNullReductionParser parserWithParseTrees:([NSSet setWithObjects:@"a", @"b", nil])])];
	STAssertEqualObjects([HammerParserParseNullFunction parseNull:parser], ([NSSet setWithObjects:@"a", @"b", nil]), @"Expected equals.");
}

@end
