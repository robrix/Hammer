//  HammerParser.h
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <Hammer/HammerVisitor.h>

@interface HammerParser : NSObject <NSCopying>

// parses a full sequence and returns the resulting parse trees
-(NSSet *)parseFull:(id<NSFastEnumeration>)sequence;

// parses a given term, returning the derivative of self with respect to that term
-(HammerParser *)parse:(id)term;

// collapses the parser to its corresponding parse forest
-(NSSet *)parseNull;

// whether or not it can parse the null (empty) string
@property (nonatomic, readonly, getter = isNullable) bool nullable;

// whether or not the language this parser parses contains only the empty string
@property (nonatomic, readonly, getter = isNull) bool null;

// whether or not the language this parser parses contains nothing
@property (nonatomic, readonly, getter = isEmpty) bool empty;

@end


@interface HammerParser () <HammerVisitable> // intended for subclassing

-(HammerParser *)parseDerive:(id)term;

@end
