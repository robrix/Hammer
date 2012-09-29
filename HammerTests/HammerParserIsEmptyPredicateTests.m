//  HammerParserIsEmptyPredicateTests.m
//  Created by Rob Rix on 2012-09-29.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerParserIsEmptyPredicate.h"
#import <Hammer/Hammer.h>

@interface HammerParserIsEmptyPredicateTests : SenTestCase
@end

@implementation HammerParserIsEmptyPredicateTests

-(void)testTheEmptyParserIsEmpty {
	STAssertTrue([HammerParserIsEmptyPredicate isEmpty:[HammerEmptyParser parser]], @"Expected true.");
}

-(void)testTheNullParserIsNotEmpty {
	STAssertFalse([HammerParserIsEmptyPredicate isEmpty:[HammerNullParser parser]], @"Expected false.");
}

-(void)testNullReductionParsersAreNotEmpty {
	STAssertFalse([HammerParserIsEmptyPredicate isEmpty:[HammerNullReductionParser parserWithParseTrees:[NSSet set]]], @"Expected false.");
}


-(void)testTermParsersAreNotEmpty {
	STAssertFalse([HammerParserIsEmptyPredicate isEmpty:[HammerTermParser parserWithTerm:@""]], @"Expected false.");
}


-(void)testAlternationParsersAreEmptyIfEitherChildIsEmpty {
	STAssertFalse([HammerParserIsEmptyPredicate isEmpty:[HammerAlternationParser parserWithLeft:HammerDelay([HammerNullParser parser]) right:HammerDelay([HammerNullParser parser])]], @"Expected false.");
	STAssertTrue([HammerParserIsEmptyPredicate isEmpty:[HammerAlternationParser parserWithLeft:HammerDelay([HammerEmptyParser parser]) right:HammerDelay([HammerNullParser parser])]], @"Expected true.");
	STAssertTrue([HammerParserIsEmptyPredicate isEmpty:[HammerAlternationParser parserWithLeft:HammerDelay([HammerNullParser parser]) right:HammerDelay([HammerEmptyParser parser])]], @"Expected true.");
	STAssertTrue([HammerParserIsEmptyPredicate isEmpty:[HammerAlternationParser parserWithLeft:HammerDelay([HammerEmptyParser parser]) right:HammerDelay([HammerEmptyParser parser])]], @"Expected true.");
}

-(void)testConcatenationParsersAreEmptyIfBothTheirChildrenAreEmpty {
	STAssertFalse([HammerParserIsEmptyPredicate isEmpty:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullParser parser]) second:HammerDelay([HammerNullParser parser])]], @"Expected false.");
	STAssertFalse([HammerParserIsEmptyPredicate isEmpty:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerEmptyParser parser]) second:HammerDelay([HammerNullParser parser])]], @"Expected false.");
	STAssertFalse([HammerParserIsEmptyPredicate isEmpty:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullParser parser]) second:HammerDelay([HammerEmptyParser parser])]], @"Expected false.");
	STAssertTrue([HammerParserIsEmptyPredicate isEmpty:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerEmptyParser parser]) second:HammerDelay([HammerEmptyParser parser])]], @"Expected true.");
}

-(void)testReductionParsersAreEmptyIfTheirChildrenAreEmpty {
	STAssertFalse([HammerParserIsEmptyPredicate isEmpty:[HammerReductionParser parserWithParser:HammerDelay([HammerNullParser parser]) function:HammerIdentityReductionFunction]], @"Expected false.");
	STAssertTrue([HammerParserIsEmptyPredicate isEmpty:[HammerReductionParser parserWithParser:HammerDelay([HammerEmptyParser parser]) function:HammerIdentityReductionFunction]], @"Expected true.");
}


-(void)testRecursiveAlternationParsersAreEmptyIfEitherChildIsEmpty {
	__block HammerParser *parser = [HammerConcatenationParser parserWithFirst:HammerDelay(parser) second:HammerDelay([HammerEmptyParser parser])];
	STAssertTrue([HammerParserIsEmptyPredicate isEmpty:parser], @"Expected true.");
	
	parser = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerEmptyParser parser]) second:HammerDelay(parser)];
	STAssertTrue([HammerParserIsEmptyPredicate isEmpty:parser], @"Expected true.");
}

@end
