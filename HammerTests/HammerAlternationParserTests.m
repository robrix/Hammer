//  HammerAlternationParserTests.m
//  Created by Rob Rix on 2012-08-14.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerAlternationParser.h"
#import "HammerConcatenationParser.h"
#import "HammerTermParser.h"

@interface HammerAlternationParserTests : SenTestCase
@end

@implementation HammerAlternationParserTests

-(NSSet *)parseTreesForTerm:(id)term left:(HammerParser *)left right:(HammerParser *)right {
	return [[[HammerAlternationParser parserWithLeft:HammerDelay(left) right:HammerDelay(right)] parse:term] parseNull];
}

-(void)testParsesUnambiguously {
	HammerTermParser *a = [HammerTermParser parserWithTerm:@"a"];
	HammerTermParser *b = [HammerTermParser parserWithTerm:@"b"];
	STAssertEqualObjects([self parseTreesForTerm:@"a" left:a right:b], [NSSet setWithObject:@"a"], @"Expected equal.");
	STAssertEqualObjects([self parseTreesForTerm:@"b" left:a right:b], [NSSet setWithObject:@"b"], @"Expected equal.");
}

-(void)testParsesAmbiguously {
	HammerTermParser *a = [HammerTermParser parserWithTerm:@"a"];
	STAssertEqualObjects([self parseTreesForTerm:@"a" left:a right:a], [NSSet setWithObject:@"a"], @"Expected equal.");
}


-(void)testDoesNotParseTermsNotInItsUnion {
	HammerTermParser *a = [HammerTermParser parserWithTerm:@"a"];
	STAssertEqualObjects([self parseTreesForTerm:@"b" left:a right:a], [NSSet set], @"Expected equal.");
}


-(void)testParsesRecursively {
	HammerTermParser *terminal = [HammerTermParser parserWithTerm:@"a"];
	__block HammerAlternationParser *either = nil;
	either = [HammerAlternationParser parserWithLeft:HammerDelay(either) right:HammerDelay(terminal)];
	
	STAssertEqualObjects(([either parseFull:@[@"a"]]), ([NSSet setWithObjects:@"a", nil]), @"Expected equal.");
}

@end
