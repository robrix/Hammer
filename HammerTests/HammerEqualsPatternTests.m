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
	STAssertTrue([[HammerEqualsPattern patternWithObject:identity] match:identity], @"Expected to match.");
	STAssertFalse([[HammerEqualsPattern patternWithObject:identity] match:[HammerTestIdentity new]], @"Expected not to match.");
}

-(void)testMatchesEqualObjects {
	STAssertTrue([[HammerEqualsPattern patternWithObject:@"a"] match:[@"a" mutableCopy]], @"Expected to match.");
}

-(void)testDoesNotMatchInequalObjects {
	STAssertFalse([[HammerEqualsPattern patternWithObject:@"a"] match:@"b"], @"Expected not to match.");
}

@end
