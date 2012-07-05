//  HammerReferencePatternTests.m
//  Created by Rob Rix on 2012-07-03.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerEqualsPattern.h"
#import "HammerReferencePattern.h"

@interface HammerReferencePatternTests : SenTestCase
@end

@implementation HammerReferencePatternTests

-(void)testReferencesAnotherPattern {
	HammerEqualsPattern *pattern = [HammerEqualsPattern patternWithObject:@"a"];
	HammerReferencePattern *reference = [HammerReferencePattern patternWithPattern:pattern];
	STAssertEqualObjects(reference.pattern, pattern, @"Expected to equal.");
}

-(void)testMatchesWhenItsReferencesPatternMatches {
	HammerEqualsPattern *pattern = [HammerEqualsPattern patternWithObject:@"a"];
	HammerReferencePattern *reference = [HammerReferencePattern patternWithPattern:pattern];
	STAssertTrue(HammerPatternMatch(reference, @"a"), @"Expected to match.");
	STAssertFalse(HammerPatternMatch(reference, @"b"), @"Expected not to match.");
}

-(void)testCanBeCreatedLazily {
	__block HammerEqualsPattern *pattern = [HammerEqualsPattern patternWithObject:@"a"];
	HammerReferencePattern *reference = [HammerReferencePattern patternWithLazyPattern:^{ return pattern; }];
	STAssertEqualObjects(reference.pattern, pattern, @"Expected to equal.");
}

@end
