//  HammerMemoizingVisitorTests.m
//  Created by Rob Rix on 2012-07-09.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "HammerMemoizingVisitor.h"
#import "HammerSymbolizer.h"
#import "HammerConcatenationParser.h"

@interface HammerMemoizingVisitorTests : SenTestCase <HammerParserAlgebra, HammerSymbolizer>
@end

@implementation HammerMemoizingVisitorTests

-(id)emptyParser { return nil; }
-(id)nullParser { return nil; }
-(id)nullReductionParserWithTrees:(NSSet *)trees { return nil; }
-(id)termParserWithTerm:(id)term { return nil; }
-(id)alternationParserWithLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right { return nil; }
-(id)reductionParserWithParser:(HammerLazyVisitable)parser function:(HammerReductionFunction)function { return nil; }

-(id)concatenationParserWithFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return @[[first() acceptAlgebra:self], [second() acceptAlgebra:self]];
}


-(id)symbolForObject:(id)object {
	return @"S";
}


-(void)testSymbolizesRecursiveVisits {
	__block HammerParser *parser = [HammerConcatenationParser parserWithFirst:HammerDelay(parser) second:HammerDelay(parser)];
	STAssertEqualObjects([parser acceptAlgebra:[[HammerMemoizingVisitor alloc] initWithVisitor:self symbolizer:self]], (@[@"S", @"S"]), @"Expected equals.");
}

@end
