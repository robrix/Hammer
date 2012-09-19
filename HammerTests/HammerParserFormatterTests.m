//  HammerParserFormatterTests.m
//  Created by Rob Rix on 2012-09-15.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import <Hammer/Hammer.h>
#import "HammerIdentitySymbolizer.h"
#import "HammerMemoizingVisitor.h"
#import "HammerParserFormatter.h"

@interface HammerParserFormatterTests : SenTestCase
@property (readonly) id<HammerVisitor> prettyPrinter;
@end

@implementation HammerParserFormatterTests

-(id<HammerVisitor>)prettyPrinter {
	return [[HammerMemoizingVisitor alloc] initWithVisitor:[HammerParserFormatter new] symbolizer:[HammerIdentitySymbolizer new]];
}

-(void)testFormatsTheEmptyParser {
	STAssertEqualObjects([[HammerEmptyParser parser] acceptVisitor:self.prettyPrinter], @"∅", @"Expected equals.");
}

-(void)testFormatsTheNullParser {
	STAssertEqualObjects([[HammerNullParser parser] acceptVisitor:self.prettyPrinter], @"ε", @"Expected equals.");
}

-(void)testFormatsNullReductionParsers {
	STAssertEqualObjects([[HammerNullReductionParser parserWithParseTrees:([NSSet setWithObjects:@"a", @"b", nil])] acceptVisitor:self.prettyPrinter], @"ε↓{a, b}", @"Expected equals.");
}

-(void)testFormatsTermParsers {
	STAssertEqualObjects([[HammerTermParser parserWithTerm:@"a"] acceptVisitor:self.prettyPrinter], @"'a'", @"Expected equals.");
}

-(void)testFormatsAlternationParsers {
	STAssertEqualObjects([[HammerAlternationParser parserWithLeft:HammerDelay([HammerTermParser parserWithTerm:@"a"]) right:HammerDelay([HammerTermParser parserWithTerm:@"b"])] acceptVisitor:self.prettyPrinter], @"{'a' | 'b'}", @"Expected equals.");
}

-(void)testFormatsConcatenationParsers {
	STAssertEqualObjects([[HammerConcatenationParser parserWithFirst:HammerDelay([HammerTermParser parserWithTerm:@"a"]) second:HammerDelay([HammerTermParser parserWithTerm:@"b"])] acceptVisitor:self.prettyPrinter], @"('a' 'b')", @"Expected equals.");
}

-(void)testFormatsReductionParsers {
	STAssertEqualObjects([[HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"]) function:HammerIdentityReductionFunction] acceptVisitor:self.prettyPrinter], @"'a' → ƒ", @"Expected equals.");
	STAssertEqualObjects([[HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"]) function:HammerIdentityReductionFunction] acceptVisitor:[HammerParserFormatter new]], @"'a' → ƒ", @"Expected equals.");
}

@end
