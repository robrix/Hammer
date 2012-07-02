//  HammerAlternationPatternTests.m
//  Created by Rob Rix on 12-06-26.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerAlternationPattern.h"
#import "HammerEqualsPattern.h"

@interface HammerAlternationPatternTests : SenTestCase
@property (nonatomic, readonly) HammerAlternationPattern *pattern;
@end

@implementation HammerAlternationPatternTests

-(HammerAlternationPattern *)pattern {
	return [HammerAlternationPattern patternWithLeftPattern:[HammerEqualsPattern patternWithObject:@"a"] rightPattern:[HammerEqualsPattern patternWithObject:@"b"]];
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

@end
