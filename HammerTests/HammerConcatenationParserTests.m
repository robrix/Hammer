//  HammerConcatenationParserTests.m
//  Created by Rob Rix on 2012-08-20.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerAlternationParser.h"
#import "HammerConcatenationParser.h"
#import "HammerNullParser.h"
#import "HammerTermParser.h"

@interface HammerConcatenationParserTests : SenTestCase
@end

@implementation HammerConcatenationParserTests

-(void)testParsesSequentially {
	HammerConcatenationParser *parser = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerTermParser parserWithTerm:@"a"]) second:HammerDelay([HammerTermParser parserWithTerm:@"b"])];
	NSSet *trees = [parser parseFull:@[@"a", @"b"]];
	STAssertEqualObjects(trees, [NSSet setWithObject:(@[@"a", @"b"])], @"Expected equal.");
}

-(void)testParsesRecursively {
	HammerParser *terminal = [HammerTermParser parserWithTerm:@"a"];
	__block HammerParser *branch = nil;
	HammerParser *bracketed = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerTermParser parserWithTerm:@"["]) second:HammerDelay([HammerConcatenationParser parserWithFirst:HammerDelay(branch) second:HammerDelay([HammerTermParser parserWithTerm:@"]"])])];
	branch = [HammerAlternationParser parserWithLeft:HammerDelay(terminal) right:HammerDelay(bracketed)];
	
	STAssertEqualObjects(([branch parseFull:@[@"[", @"a", @"]"]]), ([NSSet setWithObject:@[@"[", @[@"a", @"]"]]]), @"Expected equal.");
}

@end
