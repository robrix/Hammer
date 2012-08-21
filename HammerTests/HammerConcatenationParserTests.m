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
	HammerConcatenationParser *parser = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerTermParser parserWithTerm:@"a"]) second:HammerDelay([HammerTermParser parserWithTerm:@"b"])];
	NSSet *trees = [parser parseFull:@[@"a", @"b"]];
	STAssertEqualObjects(trees, ([NSSet setWithObject:@[@"a", @"b"]]), @"Expected equal.");
}

@end
