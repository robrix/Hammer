//  HammerRepetitionParserTests.m
//  Created by Rob Rix on 2012-08-29.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerRepetitionParser.h"
#import "HammerTermParser.h"

@interface HammerRepetitionParserTests : SenTestCase
@end

@implementation HammerRepetitionParserTests

-(void)testParsesSingleElements {
	HammerRepetitionParser *parser = [HammerRepetitionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"])];
	STAssertEqualObjects([parser parseFull:@[@"a"]], [NSSet setWithObject:@"a"], @"Expected equal.");
}

// parse multiple elements

// parse and produce parse trees

@end
