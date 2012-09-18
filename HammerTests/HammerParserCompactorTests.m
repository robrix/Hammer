//  HammerParserCompactorTests.m
//  Created by Rob Rix on 2012-09-17.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerParserCompactor.h"
#import <Hammer/Hammer.h>

@interface HammerParserCompactorTests : SenTestCase
@property (readonly) id<HammerVisitor> compactor;
@end

@implementation HammerParserCompactorTests

-(void)testDoesNotCompactTheEmptyParser {
	STAssertEqualObjects([HammerParserCompactor compact:[HammerEmptyParser parser]], [HammerEmptyParser parser], @"Expected equals.");
}


-(void)testDoesNotCompactTheNullParser {
	STAssertEqualObjects([HammerParserCompactor compact:[HammerNullParser parser]], [HammerNullParser parser], @"Expected equals.");
}

@end
