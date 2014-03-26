//  HammerParserEnumeratorTests.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import <Hammer/Hammer.h>
#import "HammerParserEnumerator.h"

@interface HammerParserEnumeratorTests : SenTestCase
@end

@implementation HammerParserEnumeratorTests

-(void)testIsAnEnumerator {
	STAssertTrue([HammerParserEnumerator isSubclassOfClass:[NSEnumerator class]], @"Expected true.");
}

-(void)testTakesAParserToEnumerate {
	STAssertNotNil([[HammerParserEnumerator alloc] initWithParser:[HammerEmptyParser parser]], @"Expected true.");
}

-(void)testEnumeratesTerminalParsers {
	HammerParserEnumerator *enumerator = [[HammerParserEnumerator alloc] initWithParser:[HammerEmptyParser parser]];
	STAssertEqualObjects([enumerator nextObject], [HammerEmptyParser parser], @"Expected equals.");
}

-(void)testReturnsNilImmediatelyAfterEnumeratingTerminalParsers {
	HammerParserEnumerator *enumerator = [[HammerParserEnumerator alloc] initWithParser:[HammerEmptyParser parser]];
	[enumerator nextObject];
	STAssertNil([enumerator nextObject], @"Expected nil.");
}


-(void)testRecursesIntoNonterminalParsers {
	HammerParser *parser = [HammerReductionParser parserWithParser:HammerDelay([HammerEmptyParser parser]) function:HammerIdentityReductionFunction];
	HammerParserEnumerator *enumerator = [[HammerParserEnumerator alloc] initWithParser:parser];
	STAssertEqualObjects([enumerator nextObject], parser, @"Expected equals.");
	STAssertEqualObjects([enumerator nextObject], [HammerEmptyParser parser], @"Expected equals.");
}

-(void)testRecursesDeeplyIntoNonterminalParsers {
	HammerParser *inner = [HammerReductionParser parserWithParser:HammerDelay([HammerEmptyParser parser]) function:HammerIdentityReductionFunction];
	HammerParser *outer = [HammerReductionParser parserWithParser:HammerDelay(inner) function:HammerIdentityReductionFunction];
	HammerParserEnumerator *enumerator = [[HammerParserEnumerator alloc] initWithParser:outer];
	STAssertEqualObjects([enumerator nextObject], outer, @"Expected equals.");
	STAssertEqualObjects([enumerator nextObject], inner, @"Expected equals.");
	STAssertEqualObjects([enumerator nextObject], [HammerEmptyParser parser], @"Expected equals.");
}


-(void)testBranchesLeftToRightIntoBinaryNonterminalParsers {
	HammerParser *parser = [HammerAlternationParser parserWithLeft:HammerDelay([HammerTermParser parserWithTerm:@"a"]) right:HammerDelay([HammerTermParser parserWithTerm:@"b"])];
	HammerParserEnumerator *enumerator = [[HammerParserEnumerator alloc] initWithParser:parser];
	STAssertEqualObjects([enumerator nextObject], parser, @"Expected equals.");
	STAssertEqualObjects([enumerator nextObject], [HammerTermParser parserWithTerm:@"a"], @"Expected equals.");
	STAssertEqualObjects([enumerator nextObject], [HammerTermParser parserWithTerm:@"b"], @"Expected equals.");
}

-(void)testBranchesDepthFirstIntoBinaryNonterminalParsers {
	HammerParser *first = [HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"]) function:HammerIdentityReductionFunction];
	HammerParser *second = [HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"b"]) function:HammerIdentityReductionFunction];
	HammerParser *root = [HammerConcatenationParser parserWithFirst:HammerDelay(first) second:HammerDelay(second)];
	HammerParserEnumerator *enumerator = [[HammerParserEnumerator alloc] initWithParser:root];
	STAssertEqualObjects([enumerator nextObject], root, @"Expected equals.");
	STAssertEqualObjects([enumerator nextObject], first, @"Expected equals.");
	STAssertEqualObjects([enumerator nextObject], [HammerTermParser parserWithTerm:@"a"], @"Expected equals.");
	STAssertEqualObjects([enumerator nextObject], second, @"Expected equals.");
	STAssertEqualObjects([enumerator nextObject], [HammerTermParser parserWithTerm:@"b"], @"Expected equals.");
	STAssertNil([enumerator nextObject], @"Expected nil.");
}


-(void)testRecordsNonTerminalParsersItHasVisited {
	HammerParser *parser = [HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"]) function:HammerIdentityReductionFunction];
	HammerParserEnumerator *enumerator = [[HammerParserEnumerator alloc] initWithParser:parser];
	[enumerator nextObject];
	
	STAssertTrue([enumerator hasVisitedParser:parser], @"Expected true.");
}


-(void)testPrunesRecursiveBranches {
	__block HammerParser *parser = [HammerConcatenationParser parserWithFirst:HammerDelay(parser) second:HammerDelay([HammerNullParser parser])];
	HammerParserEnumerator *enumerator = [[HammerParserEnumerator alloc] initWithParser:parser];
	STAssertEqualObjects([enumerator nextObject], parser, @"Expected equals.");
	STAssertEqualObjects([enumerator nextObject], [HammerNullParser parser], @"Expected equals.");
	STAssertNil([enumerator nextObject], @"Expected nil.");
}

@end
