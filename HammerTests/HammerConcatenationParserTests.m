//  HammerConcatenationParserTests.m
//  Created by Rob Rix on 2012-08-20.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerConcatenationParser.h"
#import "HammerTermParser.h"


@interface HammerConcatenationParserTests : SenTestCase
@end

@implementation HammerConcatenationParserTests

-(void)testParsesSequentially {
	HammerConcatenationParser *parser = [HammerConcatenationParser parserWithLeft:HammerDelay([HammerTermParser parserWithTerm:@"a"]) right:HammerDelay([HammerTermParser parserWithTerm:@"b"])];
	HammerParser *intermediate = [parser parse:@"a"];
	STAssertEqualObjects([intermediate parseNull], [NSSet setWithObject:@"a"], @"Expected equal.");
	HammerParser *final = [intermediate parse:@"b"];
	STAssertEqualObjects([final parseNull], ([NSSet setWithObjects:@"a", @"b", nil]), @"Expected equal.");
}

@end
