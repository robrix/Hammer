//  HammerVisitor.h
//  Created by Rob Rix on 2012-09-10.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerLaziness.h>
#import <Hammer/HammerReductionFunction.h>

@protocol HammerVisitable;

typedef id<HammerVisitable> (^HammerLazyVisitable)();

@protocol HammerVisitor <NSObject>

-(id)emptyParser;
-(id)nullParser;

-(id)nullReductionParserWithTrees:(NSSet *)trees;

-(id)termParserWithTerm:(id)term;

-(id)alternationParserWithLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right;
-(id)concatenationParserWithFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second;
-(id)reductionParserWithParser:(HammerLazyVisitable)parser function:(HammerReductionFunction)function;

@end

@protocol HammerVisitable <NSObject>

-(id)acceptVisitor:(id<HammerVisitor>)algebra;

@end
