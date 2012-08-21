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
	NSSet *trees = [parser parseFull:@[@"a", @"b"]];
	STAssertEqualObjects(trees, ([NSSet setWithObjects:@"a", @"b", nil]), @"Expected equal.");
}

@end
