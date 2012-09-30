//  HammerParserIsEqualPredicateTests.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import <Hammer/Hammer.h>
#import "HammerParserIsEqualPredicate.h"

@interface HammerParserIsEqualPredicateTests : SenTestCase
@end

@implementation HammerParserIsEqualPredicateTests

-(void)testTheEmptyParserIsEqualToItself {
	STAssertTrue([HammerParserIsEqualPredicate isParser:[HammerEmptyParser parser] equalToParser:[HammerEmptyParser parser]], @"Expected true.");
}

-(void)testTheEmptyParserIsNotEqualToOtherParsers {
	STAssertFalse([HammerParserIsEqualPredicate isParser:[HammerEmptyParser parser] equalToParser:[HammerNullParser parser]], @"Expected false.");
}


-(void)testTheNullParserIsEqualToItself {
	STAssertTrue([HammerParserIsEqualPredicate isParser:[HammerNullParser parser] equalToParser:[HammerNullParser parser]], @"Expected true.");
}

-(void)testTheNullParserIsNotEqualToNullReductionParsers {
	STAssertFalse([HammerParserIsEqualPredicate isParser:[HammerNullParser parser] equalToParser:[HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]]], @"Expected false.");
}


-(void)testNullReductionParsersAreEqualIfTheirParseTreesAreEqual {
	STAssertTrue([HammerParserIsEqualPredicate isParser:[HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]] equalToParser:[HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]]], @"Expected true.");
}


-(void)testTermParsersAreEqualIfTheirTermsAreEqual {
	STAssertTrue([HammerParserIsEqualPredicate isParser:[HammerTermParser parserWithTerm:@"a"] equalToParser:[HammerTermParser parserWithTerm:@"a"]], @"Expected equal.");
}


-(void)testAlternationParsersAreEqualIfTheirChildrenAreEqual {
	STAssertTrue([HammerParserIsEqualPredicate isParser:[HammerAlternationParser parserWithLeft:HammerDelay([HammerNullParser parser]) right:HammerDelay([HammerEmptyParser parser])] equalToParser:[HammerAlternationParser parserWithLeft:HammerDelay([HammerNullParser parser]) right:HammerDelay([HammerEmptyParser parser])]], @"Expected equal.");
}

@end
