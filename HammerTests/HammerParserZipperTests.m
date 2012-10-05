//  HammerParserZipperTests.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import <Hammer/Hammer.h>
#import "HammerParserZipper.h"

@interface HammerParserZipperTests : SenTestCase
@end

@implementation HammerParserZipperTests

-(void)testZippingTerminalParsersYieldsAnArrayOfTheParsers {
	__block NSUInteger count = 0;
	[HammerParserZipper zip:@[[HammerEmptyParser parser]] block:^(NSArray *parsers, bool *stop) {
		STAssertEqualObjects(parsers, @[[HammerEmptyParser parser]], @"Expected equals.");
		count++;
	}];
	STAssertEquals(count, (NSUInteger)1, @"Expected equals.");
}


-(void)testZippingNonterminalParsersRecursesIntoTheirChildren {
	NSMutableArray *visited = [NSMutableArray new];
	HammerParser *reduction = [HammerReductionParser parserWithParser:HammerDelay([HammerNullParser parser]) function:HammerIdentityReductionFunction];
	[HammerParserZipper zip:@[reduction] block:^(NSArray *parsers, bool *stop) {
		[visited addObject:parsers.lastObject];
	}];
	STAssertEqualObjects(visited, (@[reduction, [HammerNullParser parser]]), @"Expected equals.");
}


-(void)testZippingTerminalAndNonterminalParsersRecursesToTheDepthOfTheMaximum {
	HammerParser *nonterminal = [HammerReductionParser parserWithParser:HammerDelay([HammerNullParser parser]) function:HammerIdentityReductionFunction];
	HammerParser *terminal = [HammerNullParser parser];
	
	NSMutableArray *tuples = [NSMutableArray new];
	[HammerParserZipper zip:@[nonterminal, terminal] block:^(NSArray *parsers, bool *stop) {
		[tuples addObject:parsers];
	}];
	
	STAssertEqualObjects(tuples, (@[@[nonterminal, terminal], @[terminal, [NSNull null]]]), @"Expected equals.");
}

@end
