//  HammerParserDescriptionVisitorTests.m
//  Created by Rob Rix on 2012-09-15.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import <Hammer/Hammer.h>
#import "HammerIdentitySymbolizer.h"
#import "HammerMemoizingVisitor.h"
#import "HammerParserDescriptionVisitor.h"

@interface HammerParserDescriptionVisitorTests : SenTestCase
@property (readonly) id<HammerVisitor> prettyPrinter;
@end

@implementation HammerParserDescriptionVisitorTests

-(id<HammerVisitor>)prettyPrinter {
	return [[HammerMemoizingVisitor alloc] initWithVisitor:[HammerParserDescriptionVisitor new] symbolizer:[HammerIdentitySymbolizer new]];
}

-(void)testDescribesTheEmptyParser {
	STAssertEqualObjects([[HammerEmptyParser parser] acceptVisitor:self.prettyPrinter], @"∅", @"Expected equals.");
}

-(void)testDescribesTheNullParser {
	STAssertEqualObjects([[HammerNullParser parser] acceptVisitor:self.prettyPrinter], @"ε", @"Expected equals.");
}

-(void)testDescribesNullReductionParsers {
	STAssertEqualObjects([[HammerNullReductionParser parserWithParseTrees:([NSSet setWithObjects:@"a", @"b", nil])] acceptVisitor:self.prettyPrinter], @"ε↓{a, b}", @"Expected equals.");
}

-(void)testDescribesTermParsers {
	STAssertEqualObjects([[HammerTermParser parserWithTerm:@"a"] acceptVisitor:self.prettyPrinter], @"'a'", @"Expected equals.");
}

-(void)testDescribesAlternationParsers {
	STAssertEqualObjects([[HammerAlternationParser parserWithLeft:HammerDelay([HammerTermParser parserWithTerm:@"a"]) right:HammerDelay([HammerTermParser parserWithTerm:@"b"])] acceptVisitor:self.prettyPrinter], @"{'a' | 'b'}", @"Expected equals.");
}

-(void)testDescribesConcatenationParsers {
	STAssertEqualObjects([[HammerConcatenationParser parserWithFirst:HammerDelay([HammerTermParser parserWithTerm:@"a"]) second:HammerDelay([HammerTermParser parserWithTerm:@"b"])] acceptVisitor:self.prettyPrinter], @"('a' 'b')", @"Expected equals.");
}

-(void)testDescribesReductionParsers {
	STAssertEqualObjects([[HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"]) function:HammerIdentityReductionFunction] acceptVisitor:self.prettyPrinter], @"'a' → ƒ", @"Expected equals.");
	STAssertEqualObjects([[HammerReductionParser parserWithParser:HammerDelay([HammerTermParser parserWithTerm:@"a"]) function:HammerIdentityReductionFunction] acceptVisitor:[HammerParserDescriptionVisitor new]], @"'a' → ƒ", @"Expected equals.");
}

@end
