//  HammerPatternTests.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerAlternationPattern.h"
#import "HammerConcatenationPattern.h"
#import "HammerPattern.h"
#import "HammerEqualsPattern.h"
#import "HammerRepetitionPattern.h"

@interface NSObject (HammerEnumerator)

@property (nonatomic, readonly) NSEnumerator *objectEnumerator;

@end

@implementation NSObject (HammerEnumerator)

-(NSEnumerator *)objectEnumerator {
	return [[NSArray arrayWithObject:self] objectEnumerator];
}

@end


@interface HammerPatternTests : SenTestCase
@end

@implementation HammerPatternTests

-(void)testMatchesAlternation {
	id<HammerPattern> pattern = [HammerAlternationPattern patternWithLeftPattern:HammerDelayPattern([HammerEqualsPattern patternWithObject:@"a"]) rightPattern:HammerDelayPattern([HammerEqualsPattern patternWithObject:@"b"])];
	
	STAssertTrue(HammerPatternMatch(pattern, @"a"), @"Expected to match.");
	STAssertTrue(HammerPatternMatch(pattern, @"b"), @"Expected to match.");
	STAssertTrue(HammerPatternMatchSequence(pattern, @"a".objectEnumerator), @"Expected to match");
	STAssertTrue(HammerPatternMatchSequence(pattern, @"b".objectEnumerator), @"Expected to match");
	STAssertFalse(HammerPatternMatchSequence(pattern, @"c".objectEnumerator), @"Expected not to match");
	STAssertFalse(HammerPatternMatchSequence(pattern, [[NSArray arrayWithObjects:@"a", @"b", nil] objectEnumerator]), @"Expected not to match");
}

-(void)testMatchesEquality {
	id<HammerPattern> pattern = [HammerEqualsPattern patternWithObject:@"a"];
	
	STAssertTrue(HammerPatternMatchSequence(pattern, @"a".objectEnumerator), @"Expected to match.");
	STAssertFalse(HammerPatternMatchSequence(pattern, @"b".objectEnumerator), @"Expected not to match.");
	STAssertFalse(HammerPatternMatchSequence(pattern, [[NSArray arrayWithObjects:@"a", @"b", nil] objectEnumerator]), @"Expected not to match.");
}

-(void)testMatchesRepetition {
	id<HammerPattern> pattern = [HammerRepetitionPattern patternWithPattern:HammerDelayPattern([HammerEqualsPattern patternWithObject:@"a"])];
	
	STAssertTrue(HammerPatternMatch(pattern, @"a"), @"Expected to match.");
	STAssertTrue(HammerPatternMatchSequence(pattern, @"a".objectEnumerator), @"Expected to match.");
	STAssertTrue(HammerPatternMatchSequence(pattern, [[NSArray arrayWithObjects:@"a", @"a", nil] objectEnumerator]), @"Expected to match.");
	STAssertFalse(HammerPatternMatchSequence(pattern, @"b".objectEnumerator), @"Expected not to match.");
	STAssertFalse(HammerPatternMatchSequence(pattern, [[NSArray arrayWithObjects:@"a", @"b", nil] objectEnumerator]), @"Expected not to match.");
}

-(void)testMatchesConcatenation {
	id<HammerPattern> pattern = [HammerConcatenationPattern patternWithLeftPattern:[HammerEqualsPattern patternWithObject:@"a"] rightPattern:[HammerEqualsPattern patternWithObject:@"b"]];
	
	STAssertTrue(HammerPatternMatchSequence(pattern, [[NSArray arrayWithObjects:@"a", @"b", nil] objectEnumerator]), @"Expected to match.");
	STAssertFalse(HammerPatternMatchSequence(pattern, @"a".objectEnumerator), @"Expected not to match.");
	STAssertFalse(HammerPatternMatchSequence(pattern, [[NSArray arrayWithObjects:@"a", @"a", nil] objectEnumerator]), @"Expected not to match.");
	STAssertFalse(HammerPatternMatchSequence(pattern, [[NSArray arrayWithObjects:@"a", @"b", @"c", nil] objectEnumerator]), @"Expected not to match.");
}

@end
