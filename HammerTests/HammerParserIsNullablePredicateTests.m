//  HammerParserIsNullablePredicateTests.m
//  Created by Rob Rix on 2012-09-29.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerParserIsNullablePredicate.h"
#import <Hammer/Hammer.h>

@interface HammerParserIsNullablePredicateTests : SenTestCase
@end

@implementation HammerParserIsNullablePredicateTests

-(void)testTheEmptyParserIsNotNullable {
	STAssertFalse([HammerParserIsNullablePredicate isNullable:[HammerEmptyParser parser]], @"Expected false.");
}

-(void)testTheNullParserIsNullable {
	STAssertTrue([HammerParserIsNullablePredicate isNullable:[HammerNullParser parser]], @"Expected true.");
}

-(void)testNullReductionParsersAreNullable {
	STAssertTrue([HammerParserIsNullablePredicate isNullable:[HammerNullReductionParser parserWithParseTrees:[NSSet set]]], @"Expected true.");
}


-(void)testTermParsersAreNotNullable {
	STAssertFalse([HammerParserIsNullablePredicate isNullable:[HammerTermParser parserWithTerm:@""]], @"Expected false.");
}


-(void)testAlternationParsersAreNullableIfEitherChildIsNullable {
	STAssertTrue([HammerParserIsNullablePredicate isNullable:[HammerAlternationParser parserWithLeft:HammerDelay([HammerNullParser parser]) right:HammerDelay([HammerNullParser parser])]], @"Expected true.");
	STAssertTrue([HammerParserIsNullablePredicate isNullable:[HammerAlternationParser parserWithLeft:HammerDelay([HammerEmptyParser parser]) right:HammerDelay([HammerNullParser parser])]], @"Expected true.");
	STAssertTrue([HammerParserIsNullablePredicate isNullable:[HammerAlternationParser parserWithLeft:HammerDelay([HammerNullParser parser]) right:HammerDelay([HammerEmptyParser parser])]], @"Expected true.");
	STAssertFalse([HammerParserIsNullablePredicate isNullable:[HammerAlternationParser parserWithLeft:HammerDelay([HammerEmptyParser parser]) right:HammerDelay([HammerEmptyParser parser])]], @"Expected false.");
}

-(void)testConcatenationParsersAreNullableIfBothChildrenAreNullable {
	STAssertTrue([HammerParserIsNullablePredicate isNullable:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullParser parser]) second:HammerDelay([HammerNullParser parser])]], @"Expected true.");
	STAssertFalse([HammerParserIsNullablePredicate isNullable:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerEmptyParser parser]) second:HammerDelay([HammerNullParser parser])]], @"Expected false.");
	STAssertFalse([HammerParserIsNullablePredicate isNullable:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullParser parser]) second:HammerDelay([HammerEmptyParser parser])]], @"Expected false.");
	STAssertFalse([HammerParserIsNullablePredicate isNullable:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerEmptyParser parser]) second:HammerDelay([HammerEmptyParser parser])]], @"Expected false.");
}

-(void)testReductionParsersAreNullableIfTheirChildrenAreNullable {
	STAssertTrue([HammerParserIsNullablePredicate isNullable:[HammerReductionParser parserWithParser:HammerDelay([HammerNullParser parser]) function:HammerIdentityReductionFunction]], @"Expected true.");
	STAssertFalse([HammerParserIsNullablePredicate isNullable:[HammerReductionParser parserWithParser:HammerDelay([HammerEmptyParser parser]) function:HammerIdentityReductionFunction]], @"Expected false.");
}


-(void)testRecursiveAlternationParsersAreNullableIfEitherChildIsNullable {
	__block HammerParser *parser = [HammerAlternationParser parserWithLeft:HammerDelay(parser) right:HammerDelay([HammerNullParser parser])];
	STAssertTrue([HammerParserIsNullablePredicate isNullable:parser], @"Expected true.");
	
	parser = [HammerAlternationParser parserWithLeft:HammerDelay([HammerNullParser parser]) right:HammerDelay(parser)];
	STAssertTrue([HammerParserIsNullablePredicate isNullable:parser], @"Expected true.");
	
	parser = [HammerAlternationParser parserWithLeft:HammerDelay([HammerEmptyParser parser]) right:HammerDelay(parser)];
	STAssertFalse([HammerParserIsNullablePredicate isNullable:parser], @"Expected false.");
	
	parser = [HammerAlternationParser parserWithLeft:HammerDelay(parser) right:HammerDelay(parser)];
	STAssertFalse([HammerParserIsNullablePredicate isNullable:parser], @"Expected false.");
}

@end
