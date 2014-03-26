//  HammerParserIsNullPredicateTests.m
//  Created by Rob Rix on 2012-09-20.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerParserIsNullPredicate.h"
#import <Hammer/Hammer.h>

@interface HammerParserIsNullPredicateTests : SenTestCase
@end

@implementation HammerParserIsNullPredicateTests

-(void)testTheEmptyParserIsNotNull {
	STAssertFalse([HammerParserIsNullPredicate isNull:[HammerEmptyParser parser]], @"Expected false.");
}

-(void)testTheNullParserIsNull {
	STAssertTrue([HammerParserIsNullPredicate isNull:[HammerNullParser parser]], @"Expected true.");
}

-(void)testNullReductionParsersAreNull {
	STAssertTrue([HammerParserIsNullPredicate isNull:[HammerNullReductionParser parserWithParseTrees:[NSSet set]]], @"Expected true.");
}


-(void)testTermParsersAreNotNull {
	STAssertFalse([HammerParserIsNullPredicate isNull:[HammerTermParser parserWithTerm:@"a"]], @"Expected false.");
}


-(void)testAlternationParsersAreNullIfBothTheirChildrenAreNull {
	STAssertTrue([HammerParserIsNullPredicate isNull:[HammerAlternationParser parserWithLeft:HammerDelay([HammerNullParser parser]) right:HammerDelay([HammerNullParser parser])]], @"Expected true.");
	STAssertFalse([HammerParserIsNullPredicate isNull:[HammerAlternationParser parserWithLeft:HammerDelay([HammerEmptyParser parser]) right:HammerDelay([HammerNullParser parser])]], @"Expected false.");
	STAssertFalse([HammerParserIsNullPredicate isNull:[HammerAlternationParser parserWithLeft:HammerDelay([HammerNullParser parser]) right:HammerDelay([HammerEmptyParser parser])]], @"Expected false.");
	STAssertFalse([HammerParserIsNullPredicate isNull:[HammerAlternationParser parserWithLeft:HammerDelay([HammerEmptyParser parser]) right:HammerDelay([HammerEmptyParser parser])]], @"Expected false.");
}

-(void)testConcatenationParsersAreNullIfBothTheirChildrenAreNull {
	STAssertTrue([HammerParserIsNullPredicate isNull:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullParser parser]) second:HammerDelay([HammerNullParser parser])]], @"Expected true.");
	STAssertFalse([HammerParserIsNullPredicate isNull:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerEmptyParser parser]) second:HammerDelay([HammerNullParser parser])]], @"Expected false.");
	STAssertFalse([HammerParserIsNullPredicate isNull:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullParser parser]) second:HammerDelay([HammerEmptyParser parser])]], @"Expected false.");
	STAssertFalse([HammerParserIsNullPredicate isNull:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerEmptyParser parser]) second:HammerDelay([HammerEmptyParser parser])]], @"Expected false.");
}

-(void)testReductionParsersAreNullIfTheirChildrenAreNull {
	STAssertTrue([HammerParserIsNullPredicate isNull:[HammerReductionParser parserWithParser:HammerDelay([HammerNullParser parser]) function:HammerIdentityReductionFunction]], @"Expected true.");
	STAssertFalse([HammerParserIsNullPredicate isNull:[HammerReductionParser parserWithParser:HammerDelay([HammerEmptyParser parser]) function:HammerIdentityReductionFunction]], @"Expected false.");
}


-(void)testRecursiveConcatenationParsersAreNullIfEitherChildIsNull {
	__block HammerParser *parser = [HammerConcatenationParser parserWithFirst:HammerDelay(parser) second:HammerDelay([HammerNullParser parser])];
	STAssertTrue([HammerParserIsNullPredicate isNull:parser], @"Expected true.");
	
	parser = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullParser parser]) second:HammerDelay(parser)];
	STAssertTrue([HammerParserIsNullPredicate isNull:parser], @"Expected true.");
}

@end
