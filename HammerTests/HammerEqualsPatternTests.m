//  HammerEqualsPatternTests.m
//  Created by Rob Rix on 12-06-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEqualsPattern.h"
#import <SenTestingKit/SenTestingKit.h>

@interface HammerTestIdentity : NSObject
@end

@implementation HammerTestIdentity

-(BOOL)isEqual:(id)object {
	return object == self;
}

@end


@interface HammerEqualsPatternTests : SenTestCase
@end

@implementation HammerEqualsPatternTests

-(void)testMatchesIdenticalObjects {
	HammerTestIdentity *identity = [HammerTestIdentity new];
	STAssertTrue(HammerPatternMatch([HammerEqualsPattern patternWithObject:identity], identity), @"Expected to match.");
	STAssertFalse(HammerPatternMatch([HammerEqualsPattern patternWithObject:identity], [HammerTestIdentity new]), @"Expected not to match.");
}

-(void)testMatchesEqualObjects {
	STAssertTrue(HammerPatternMatch([HammerEqualsPattern patternWithObject:@"a"], [@"a" mutableCopy]), @"Expected to match.");
}

-(void)testDoesNotMatchInequalObjects {
	STAssertFalse(HammerPatternMatch([HammerEqualsPattern patternWithObject:@"a"], @"b"), @"Expected not to match.");
}

@end
