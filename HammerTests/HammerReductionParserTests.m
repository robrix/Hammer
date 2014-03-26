//  HammerReductionParserTests.m
//  Created by Rob Rix on 2012-09-02.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerReductionParser.h"
#import "HammerTermParser.h"

@interface HammerReductionParserTests : SenTestCase
@end

@implementation HammerReductionParserTests

-(void)testParsesWhatItsChildParserParses {
	HammerParser *reduction = [HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"]) function:HammerIdentityReductionFunction];
	STAssertEqualObjects([reduction parseFull:@[@"a"]], [NSSet setWithObject:@"a"], @"Expected equal.");
}

-(void)testTransformsParseTreesByItsFunction {
	HammerParser *reduction = [HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"]) function:^(id string){
		return [string stringByAppendingString:@"!"];
	}];
	STAssertEqualObjects([reduction parseFull:@[@"a"]], [NSSet setWithObject:@"a!"], @"Expected equal.");
}

@end
