//  HammerParserDerivativeFunctionTests.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import <Hammer/Hammer.h>
#import "HammerParserDerivativeFunction.h"

@interface HammerParserDerivativeFunctionTests : SenTestCase
@end

@implementation HammerParserDerivativeFunctionTests

-(void)testTheDerivativeOfTheEmptyParserIsItself {
	STAssertEqualObjects([HammerParserDerivativeFunction derivatativeOfParser:[HammerEmptyParser parser] withRespectToTerm:@"a"], [HammerEmptyParser parser], @"Expected equals.");
}

-(void)testTheDerivativeOfTheNullParserIsTheEmptyParser {
	STAssertEqualObjects([HammerParserDerivativeFunction derivatativeOfParser:[HammerNullParser parser] withRespectToTerm:@"a"], [HammerEmptyParser parser], @"Expected equals.");
}

-(void)testTheDerivativeOfNullReductionParsersIsTheEmptyParser {
	STAssertEqualObjects([HammerParserDerivativeFunction derivatativeOfParser:[HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]] withRespectToTerm:@"a"], [HammerEmptyParser parser], @"Expected equals.");
}


-(void)testTheDerivativeOfTermParsersWithRespectToTheirTermsIsANullReductionParserContainingTheirTerm {
	STAssertEqualObjects([HammerParserDerivativeFunction derivatativeOfParser:[HammerTermParser parserWithTerm:@"a"] withRespectToTerm:@"a"], [HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]], @"Expected equals.");
}

-(void)testTheDerivativeOfTermParsersWithRespectToOtherTermsIsTheEmptyParser {
	STAssertEqualObjects([HammerParserDerivativeFunction derivatativeOfParser:[HammerTermParser parserWithTerm:@"b"] withRespectToTerm:@"a"], [HammerEmptyParser parser], @"Expected equals.");
}


-(void)testTheDerivativeOfAlternationParsersIsTheAlternationOfTheDerivativesOfTheirChildren {
	STAssertEqualObjects([HammerParserDerivativeFunction derivatativeOfParser:[HammerAlternationParser parserWithLeft:HammerDelay([HammerTermParser parserWithTerm:@"a"]) right:HammerDelay([HammerTermParser parserWithTerm:@"b"])] withRespectToTerm:@"a"], [HammerAlternationParser parserWithLeft:HammerDelay([HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]]) right:HammerDelay([HammerEmptyParser parser])], @"Expected equals.");
}

@end
