//  HammerParserDerivativeFunctionTests.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import <Hammer/Hammer.h>
#import "HammerParserDerivativeFunction.h"
#import "HammerParserFormatter.h"
#import "HammerParserIsEqualPredicate.h"

@interface HammerParserDerivativeFunctionTests : SenTestCase
@end

@implementation HammerParserDerivativeFunctionTests

-(void)assertParser:(HammerParser *)parser1 isEqualToParser:(HammerParser *)parser2 {
	STAssertTrue([HammerParserIsEqualPredicate isParser:parser1 equalToParser:parser2], @"Expected %@ equal to %@.", [HammerParserFormatter format:parser1], [HammerParserFormatter format:parser2]);
}


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


-(void)testAlternationParsersBecomeTheAlternationOfTheDerivativesOfTheirChildren {
	HammerParser *expected = [HammerAlternationParser parserWithLeft:HammerDelay([HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]]) right:HammerDelay([HammerEmptyParser parser])];
	HammerParser *derivative = [HammerParserDerivativeFunction derivatativeOfParser:[HammerAlternationParser parserWithLeft:HammerDelay([HammerTermParser parserWithTerm:@"a"]) right:HammerDelay([HammerTermParser parserWithTerm:@"b"])] withRespectToTerm:@"a"];
	[self assertParser:derivative isEqualToParser:expected];
}


-(void)testConcatenationParsersAlternateAttemptsToParseTheFirstParserWithSkippingItWhenTheFirstParserIsNullable {
	HammerParser *original = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullParser parser]) second:HammerDelay([HammerTermParser parserWithTerm:@"a"])];
	HammerParser *nulledFirst = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@""]]) second:HammerDelay([HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]])];
	HammerParser *parsedFirst = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerEmptyParser parser]) second:HammerDelay([HammerTermParser parserWithTerm:@"a"])];
	HammerParser *expected = [HammerAlternationParser parserWithLeft:HammerDelay(nulledFirst) right:HammerDelay(parsedFirst)];
	HammerParser *derivative = [HammerParserDerivativeFunction derivatativeOfParser:original withRespectToTerm:@"a"];
	[self assertParser:derivative isEqualToParser:expected];
}

-(void)testConcatenationParsersDoNotAttemptToSkipTheFirstParserWhenItIsNotNullable {
	HammerParser *original = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerTermParser parserWithTerm:@"a"]) second:HammerDelay([HammerTermParser parserWithTerm:@"b"])];
	HammerParser *expected = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]]) second:HammerDelay([HammerTermParser parserWithTerm:@"b"])];
	HammerParser *derivative = [HammerParserDerivativeFunction derivatativeOfParser:original withRespectToTerm:@"a"];
	[self assertParser:derivative isEqualToParser:expected];
}


-(void)testReductionsReduceTheDerivativeOfTheirChildren {
	HammerParser *reduction = [HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"]) function:HammerIdentityReductionFunction];
	HammerParser *expected = [HammerReductionParser parserWithParser:HammerDelay([HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]]) function:HammerIdentityReductionFunction];
	HammerParser *derivative = [HammerParserDerivativeFunction derivatativeOfParser:reduction withRespectToTerm:@"a"];
	[self assertParser:derivative isEqualToParser:expected];
}

@end
