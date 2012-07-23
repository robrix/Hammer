//  HammerPatternDescriptionVisitorTests.m
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerAlternationPattern.h"
#import "HammerConcatenationPattern.h"
#import "HammerDerivativePattern.h"
#import "HammerNullPattern.h"
#import "HammerEqualsPattern.h"
#import "HammerEmptyPattern.h"
#import "HammerPatternDescriptionVisitor.h"
#import "HammerRepetitionPattern.h"

@interface HammerPatternDescriptionVisitorTests : SenTestCase
@property (nonatomic, readonly) HammerPatternDescriptionVisitor *visitor;
@end

@implementation HammerPatternDescriptionVisitorTests

-(HammerPatternDescriptionVisitor *)visitor {
	return [HammerPatternDescriptionVisitor new];
}

-(HammerEqualsPattern *)eq:(id)object {
	return [HammerEqualsPattern patternWithObject:object];
}

-(id)visit:(id<HammerPattern>)pattern {
	return [HammerDerivativePattern(pattern) acceptVisitor:self.visitor];
}

//-(void)testDescribesPatterns {
//	
//}


-(void)testDescribesEqualsPatternsAsTheirOperands {
	STAssertEqualObjects([self visit:[self eq:@"a"]], @"'a'", @"Expected to match.");
}

-(void)testDescribesEpsilonWithItsSymbol {
	STAssertEqualObjects([self visit:[HammerNullPattern pattern]], @"ε", @"Expected to match.");
}

-(void)testDescribesNullWithItsSymbol {
	STAssertEqualObjects([self visit:[HammerEmptyPattern pattern]], @"∅", @"Expected to match.");
}

-(void)testDescribesRepetitionSuffixedWithTheKleeneStar {
	STAssertEqualObjects([self visit:[HammerRepetitionPattern patternWithPattern:HammerDelayPattern([self eq:@"a"])]], @"'a'*", @"Expected to match.");
}

-(void)testDescribesAlternationJoinedByPipes {
	STAssertEqualObjects([self visit:([HammerAlternationPattern patternWithPatterns:@[HammerDelayPattern([self eq:@"a"]), HammerDelayPattern([self eq:@"b"]), HammerDelayPattern([self eq:@"c"])]])], @"{'a' | {'b' | 'c'}}", @"Expected to match.");
}

-(void)testDescribesConcatenationJoinedBySpaces {
	STAssertEqualObjects([self visit:([HammerConcatenationPattern patternWithPatterns:@[HammerDelayPattern([self eq:@"a"]), HammerDelayPattern([self eq:@"b"]), HammerDelayPattern([self eq:@"c"])]])], @"('a' ('b' 'c'))", @"Expected to match.");
}

@end
