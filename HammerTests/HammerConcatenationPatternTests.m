//  HammerConcatenationPatternTests.m
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerConcatenationPattern.h"
#import "HammerEpsilonPattern.h"
#import "HammerEqualsPattern.h"

@interface HammerConcatenationPatternTests : SenTestCase
@end

@implementation HammerConcatenationPatternTests

-(void)testNullaryListsBecomeEpsilon {
	STAssertEqualObjects([HammerConcatenationPattern patternWithPatterns:[NSArray array]], [HammerEpsilonPattern pattern], @"Expected to match.");
}

-(void)testUnaryListsBecomeIdentity {
	id<HammerPattern> pattern = [HammerEqualsPattern patternWithObject:@"a"];
	STAssertEqualObjects([HammerConcatenationPattern patternWithPatterns:[NSArray arrayWithObject:HammerDelayPattern(pattern)]], pattern, @"Expected to match.");
}

-(void)testBinaryListsBecomeAConcatenationPattern {
	HammerLazyPattern a = HammerDelayPattern([HammerEqualsPattern patternWithObject:@"a"]);
	HammerLazyPattern b = HammerDelayPattern([HammerEqualsPattern patternWithObject:@"b"]);
	id<HammerPattern> pattern = [HammerConcatenationPattern patternWithLeftPattern:a rightPattern:b];
	
	STAssertEqualObjects(([HammerConcatenationPattern patternWithPatterns:@[a, b]]), pattern, @"Expected to match.");
}

@end
