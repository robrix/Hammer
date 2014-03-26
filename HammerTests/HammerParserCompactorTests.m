//  HammerParserCompactorTests.m
//  Created by Rob Rix on 2012-09-17.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerParserCompactor.h"
#import <Hammer/Hammer.h>

@interface HammerParserCompactorTests : SenTestCase
@property (readonly) id<HammerVisitor> compactor;
@end

@implementation HammerParserCompactorTests

-(void)testDoesNotCompactTheEmptyParser {
	STAssertEqualObjects([HammerParserCompactor compact:[HammerEmptyParser parser]], [HammerEmptyParser parser], @"Expected equals.");
}

-(void)testDoesNotCompactTheNullParser {
	STAssertEqualObjects([HammerParserCompactor compact:[HammerNullParser parser]], [HammerNullParser parser], @"Expected equals.");
}

-(void)testCompactsNullReductionParsersWithoutParseTreesIntoNullParsers {
	STAssertEqualObjects([HammerParserCompactor compact:[HammerNullReductionParser parserWithParseTrees:[NSSet set]]], [HammerNullParser parser], @"Expected equals.");
}

-(void)testDoesNotCompactNullReductionParsersWithTrees {
	STAssertEqualObjects([HammerParserCompactor compact:[HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]]], [HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]], @"Expected equals.");
}

-(void)testDoesNotCompactTermParsers {
	STAssertEqualObjects([HammerParserCompactor compact:[HammerTermParser parserWithTerm:@"a"]], [HammerTermParser parserWithTerm:@"a"], @"Expected equals.");
}


-(void)testCompactsHalfEmptyAlternationsToTheirOtherHalf {
	STAssertEqualObjects([HammerParserCompactor compact:[HammerAlternationParser parserWithLeft:HammerDelay([HammerEmptyParser parser]) right:HammerDelay([HammerNullParser parser])]], [HammerNullParser parser], @"Expected equals.");
	STAssertEqualObjects([HammerParserCompactor compact:[HammerAlternationParser parserWithLeft:HammerDelay([HammerNullParser parser]) right:HammerDelay([HammerEmptyParser parser])]], [HammerNullParser parser], @"Expected equals.");
}

-(void)testCompactsHalfEmptyConcatenationsToEmpty {
	STAssertEqualObjects([HammerParserCompactor compact:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerEmptyParser parser]) second:HammerDelay([HammerNullParser parser])]], [HammerEmptyParser parser], @"Expected equals.");
	STAssertEqualObjects([HammerParserCompactor compact:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullParser parser]) second:HammerDelay([HammerEmptyParser parser])]], [HammerEmptyParser parser], @"Expected equals.");
}

-(void)testCompactsEmptyReductionsToEmpty {
	STAssertEqualObjects([HammerParserCompactor compact:[HammerReductionParser parserWithParser:HammerDelay([HammerEmptyParser parser]) function:HammerIdentityReductionFunction]], [HammerEmptyParser parser], @"Expected equals.");
}

@end
