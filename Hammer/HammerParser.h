//  HammerParser.h
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <Hammer/HammerParserAlgebra.h>

@interface HammerParser : NSObject <NSCopying, HammerVisitable>

-(NSSet *)parseFull:(id<NSFastEnumeration>)sequence;
-(HammerParser *)parse:(id)term;
-(NSSet *)parseNull;

// whether or not it can parse the null (empty) string
@property (nonatomic, readonly) BOOL canParseNull;

// algebraically reduced representation of self
-(HammerParser *)compact;

-(id)acceptAlgebra:(id<HammerParserAlgebra>)algebra;

@end

@interface HammerParser () // intended for subclassing

-(HammerParser *)parseDerive:(id)term;
-(NSSet *)parseNullRecursive;

@property (nonatomic, readonly) BOOL canParseNullRecursive;

-(HammerParser *)compactRecursive;

@end
