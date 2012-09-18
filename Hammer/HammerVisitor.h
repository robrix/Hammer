//  HammerVisitor.h
//  Created by Rob Rix on 2012-09-10.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <Hammer/HammerLaziness.h>

@class HammerEmptyParser, HammerNullParser, HammerNullReductionParser, HammerTermParser, HammerAlternationParser, HammerConcatenationParser, HammerReductionParser;
@protocol HammerVisitable;

typedef id<HammerVisitable> (^HammerLazyVisitable)();

@protocol HammerVisitor <NSObject>

-(id)emptyParser:(HammerEmptyParser *)parser;
-(id)nullParser:(HammerNullParser *)parser;

-(id)nullReductionParser:(HammerNullReductionParser *)parser;

-(id)termParser:(HammerTermParser *)parser;

-(id)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right;
-(id)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second;
-(id)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child;

@end

@protocol HammerVisitable <NSObject>

-(id)acceptVisitor:(id<HammerVisitor>)visitor;

@end
