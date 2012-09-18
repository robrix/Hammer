//  HammerMemoizingVisitorTests.m
//  Created by Rob Rix on 2012-07-09.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerMemoizingVisitor.h"
#import "HammerSymbolizer.h"
#import "HammerConcatenationParser.h"

@interface HammerMemoizingVisitorTests : SenTestCase <HammerVisitor, HammerSymbolizer>
@end

@implementation HammerMemoizingVisitorTests

-(id)emptyParser:(HammerEmptyParser *)parser { return nil; }
-(id)nullParser:(HammerNullParser *)parser { return nil; }
-(id)nullReductionParser:(HammerNullReductionParser *)parser { return nil; }
-(id)termParser:(HammerTermParser *)parser { return nil; }
-(id)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right { return nil; }
-(id)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child { return nil; }

-(id)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return @[[first() acceptVisitor:self], [second() acceptVisitor:self]];
}


-(id)symbolForObject:(id)object {
	return @"S";
}


-(void)testSymbolizesRecursiveVisits {
	__block HammerParser *parser = [HammerConcatenationParser parserWithFirst:HammerDelay(parser) second:HammerDelay(parser)];
	STAssertEqualObjects([parser acceptVisitor:[[HammerMemoizingVisitor alloc] initWithVisitor:self symbolizer:self]], (@[@"S", @"S"]), @"Expected equals.");
}

@end
