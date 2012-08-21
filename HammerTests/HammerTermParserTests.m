//  HammerTermParserTests.m
//  Created by Rob Rix on 2012-08-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerTermParser.h"

@interface HammerTermParserTests : SenTestCase
@end

@implementation HammerTermParserTests

-(void)testDoesNotCompact {
	HammerTermParser *parser = [HammerTermParser parserWithTerm:@"a"];
	STAssertEqualObjects([parser compact], parser, @"Expected equal.");
}

-(void)testParsesItsTerm {
	STAssertEqualObjects([[[HammerTermParser parserWithTerm:@"a"] parse:@"a"] parseNull], [NSSet setWithObject:@"a"], @"Expected equal.");
}

-(void)testDoesNotParseOtherTerms {
	STAssertEqualObjects([[[HammerTermParser parserWithTerm:@"a"] parse:@"b"] parseNull], [NSSet set], @"Expected equal.");
}

@end
