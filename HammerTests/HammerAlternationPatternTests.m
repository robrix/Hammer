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
	STAssertTrue([self.pattern match:@"a"], @"Expected to match.");
}

-(void)testMatchesItsSecondAlternative {
	STAssertTrue([self.pattern match:@"b"], @"Expected to match.");
}

-(void)testFailsToMatchWhenBothAlternativesFailToMatch {
	STAssertFalse([self.pattern match:@"c"], @"Expected not to match.");
}

@end
