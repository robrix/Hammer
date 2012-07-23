//  HammerAlternationPatternTests.m
//  Created by Rob Rix on 12-06-26.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerAlternationPattern.h"
#import "HammerNullPattern.h"
#import "HammerEqualsPattern.h"

@interface HammerAlternationPatternTests : SenTestCase
@property (nonatomic, readonly) HammerAlternationPattern *pattern;
@end

@implementation HammerAlternationPatternTests

-(HammerAlternationPattern *)pattern {
	return [HammerAlternationPattern patternWithLeftPattern:HammerDelayPattern([HammerEqualsPattern patternWithObject:@"a"]) rightPattern:HammerDelayPattern([HammerEqualsPattern patternWithObject:@"b"])];
}

-(void)testMatchesItsFirstAlternative {
	STAssertTrue(HammerPatternMatch(self.pattern, @"a"), @"Expected to match.");
}

-(void)testMatchesItsSecondAlternative {
	STAssertTrue(HammerPatternMatch(self.pattern, @"b"), @"Expected to match.");
}

-(void)testFailsToMatchWhenBothAlternativesFailToMatch {
	STAssertFalse(HammerPatternMatch(self.pattern, @"c"), @"Expected not to match.");
}


-(void)testNullaryListsBecomeEpsilon {
	STAssertEqualObjects([HammerAlternationPattern patternWithPatterns:[NSArray array]], [HammerEpsilonPattern pattern], @"Expected to match.");
}

-(void)testUnaryListsBecomeIdentity {
	id<HammerPattern> pattern = [HammerEqualsPattern patternWithObject:@"a"];
	STAssertEqualObjects([HammerAlternationPattern patternWithPatterns:[NSArray arrayWithObject:HammerDelayPattern(pattern)]], pattern, @"Expected to match.");
}

-(void)testBinaryListsBecomeAnAlternationPattern {
	HammerLazyPattern a = HammerDelayPattern([HammerEqualsPattern patternWithObject:@"a"]);
	HammerLazyPattern b = HammerDelayPattern([HammerEqualsPattern patternWithObject:@"b"]);
	id<HammerPattern> pattern = [HammerAlternationPattern patternWithLeftPattern:a rightPattern:b];
	
	STAssertEqualObjects(([HammerAlternationPattern patternWithPatterns:@[a, b]]), pattern, @"Expected to match.");
}

@end
