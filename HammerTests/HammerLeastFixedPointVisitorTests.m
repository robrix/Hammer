//  HammerLeastFixedPointVisitorTests.m
//  Created by Rob Rix on 2012-09-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import <Hammer/Hammer.h>
#import <Hammer/HammerLeastFixedPointVisitor.h>

@interface HammerLeastFixedPointVisitorTests : SenTestCase <HammerVisitor>

@property (readonly) HammerLeastFixedPointVisitor *visitor;

@end

@implementation HammerLeastFixedPointVisitorTests

-(void)testIsAVisitor {
	id<HammerVisitor> visitor = [HammerLeastFixedPointVisitor new];
	STAssertTrue([visitor conformsToProtocol:@protocol(HammerVisitor)], @"Expected true.");
}

-(void)testTakesABottomValue {
	HammerLeastFixedPointVisitor *visitor = [[HammerLeastFixedPointVisitor alloc] initWithBottom:@"bottom" visitor:self];
	STAssertEqualObjects(visitor.bottom, @"bottom", @"Expected equals.");
}

-(void)testTakesAVisitorToComputeTheLeastFixedPointOf {
	STAssertEqualObjects(self.visitor.visitor, self, @"Expected equals.");
}


-(void)testComputesTheLeastFixedPointOfAVisitorOverEmptyParsers {
	STAssertEqualObjects([[HammerEmptyParser parser] acceptVisitor:self.visitor], @NO, @"Expected equals.");
}

-(void)testComputesTheLeastFixedPointOfAVisitorOverNullParsers {
	STAssertEqualObjects([[HammerNullParser parser] acceptVisitor:self.visitor], @NO, @"Expected equals.");
}


-(void)testComputesTheLeastFixedPointOfAVisitorOverNullReductionParsers {
	STAssertEqualObjects([[HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:@"a"]] acceptVisitor:self.visitor], @NO, @"Expected equals.");
}


-(void)testComputesTheLeastFixedPointOfAVisitorOverTermParsers {
	STAssertEqualObjects([[HammerTermParser parserWithTerm:@""] acceptVisitor:self.visitor], @YES, @"Expected equals.");
}


-(void)testComputesTheLeastFixedPointOfAVisitorOverConcatenationParsers {
	HammerParser *parser = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerEmptyParser parser]) second:HammerDelay([HammerNullParser parser])];
	STAssertEqualObjects([parser acceptVisitor:self.visitor], @NO, @"Expected equals.");
	parser = [HammerConcatenationParser parserWithFirst:HammerDelay([HammerTermParser parserWithTerm:@"a"]) second:HammerDelay([HammerTermParser parserWithTerm:@"b"])];
	STAssertEqualObjects([parser acceptVisitor:self.visitor], @YES, @"Expected equals.");
}

-(void)testComputesTheLeastFixedPointOfAVisitorOverAlternationParsers {
	HammerParser *parser = [HammerAlternationParser parserWithLeft:HammerDelay([HammerEmptyParser parser]) right:HammerDelay([HammerNullParser parser])];
	STAssertEqualObjects([parser acceptVisitor:self.visitor], @NO, @"Expected equals.");
	parser = [HammerAlternationParser parserWithLeft:HammerDelay([HammerEmptyParser parser]) right:HammerDelay([HammerTermParser parserWithTerm:@"a"])];
	STAssertEqualObjects([parser acceptVisitor:self.visitor], @YES, @"Expected equals.");
}


-(void)testComputesTheLeastFixedPointOfAVisitorOverReductionParsers {
	HammerParser *parser = [HammerReductionParser parserWithParser:HammerDelay([HammerEmptyParser parser]) function:HammerIdentityReductionFunction];
	STAssertEqualObjects([parser acceptVisitor:self.visitor], @NO, @"Expected equals.");
}


-(void)testComputesTheLeastFixedPointOfAVisitorOverRecursiveConcatenationParsers {
	__block HammerParser *parser = [HammerConcatenationParser parserWithFirst:HammerDelay(parser) second:HammerDelay([HammerTermParser parserWithTerm:@"b"])];
	STAssertEqualObjects([parser acceptVisitor:self.visitor], @NO, @"Expected equals.");
}

-(void)testComputesTheLeastFixedPointOfAVisitorOverRecursiveAlternationParsers {
	__block HammerParser *parser = [HammerAlternationParser parserWithLeft:HammerDelay(parser) right:HammerDelay([HammerTermParser parserWithTerm:@"b"])];
	STAssertEqualObjects([parser acceptVisitor:self.visitor], @YES, @"Expected equals.");
}


-(id<HammerVisitor>)visitor {
	return [[HammerLeastFixedPointVisitor alloc] initWithBottom:@NO visitor:self];
}


-(id)emptyParser:(HammerEmptyParser *)parser {
	return @NO;
}

-(id)nullParser:(HammerNullParser *)parser {
	return @NO;
}

-(id)nullReductionParser:(HammerNullReductionParser *)parser {
	return @NO;
}


-(id)termParser:(HammerTermParser *)parser {
	return @YES;
}


-(id)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return @([[left() acceptVisitor:self] boolValue] || [[right() acceptVisitor:self] boolValue]);
}

-(id)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return @([[first() acceptVisitor:self] boolValue] && [[second() acceptVisitor:self] boolValue]);
}


-(id)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return [child() acceptVisitor:self];
}

@end
