//  HammerParserFormatterTests.m
//  Created by Rob Rix on 2012-09-15.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import <Hammer/Hammer.h>
#import "HammerParserFormatter.h"

@interface HammerParserFormatterTests : SenTestCase
@end

@implementation HammerParserFormatterTests

-(void)testFormatsTheEmptyParser {
	STAssertEqualObjects([HammerParserFormatter format:[HammerEmptyParser parser]], @"∅", @"Expected equals.");
}

-(void)testFormatsTheNullParser {
	STAssertEqualObjects([HammerParserFormatter format:[HammerNullParser parser]], @"ε", @"Expected equals.");
}

-(void)testFormatsNullReductionParsers {
	STAssertEqualObjects([HammerParserFormatter format:[HammerNullReductionParser parserWithParseTrees:([NSSet setWithObjects:@"a", @"b", nil])]], @"ε↓{a, b}", @"Expected equals.");
}

-(void)testFormatsTermParsers {
	STAssertEqualObjects([HammerParserFormatter format:[HammerTermParser parserWithTerm:@"a"]], @"'a'", @"Expected equals.");
}

-(void)testFormatsAlternationParsers {
	STAssertEqualObjects([HammerParserFormatter format:[HammerAlternationParser parserWithLeft:HammerDelay([HammerTermParser parserWithTerm:@"a"]) right:HammerDelay([HammerTermParser parserWithTerm:@"b"])]], @"{'a' | 'b'}", @"Expected equals.");
}

-(void)testFormatsConcatenationParsers {
	STAssertEqualObjects([HammerParserFormatter format:[HammerConcatenationParser parserWithFirst:HammerDelay([HammerTermParser parserWithTerm:@"a"]) second:HammerDelay([HammerTermParser parserWithTerm:@"b"])]], @"('a' 'b')", @"Expected equals.");
}

-(void)testFormatsReductionParsers {
	STAssertEqualObjects([HammerParserFormatter format:[HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"]) function:HammerIdentityReductionFunction]], @"'a' → ƒ", @"Expected equals.");
}

@end
