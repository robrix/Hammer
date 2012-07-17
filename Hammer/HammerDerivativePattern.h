//  HammerDerivativePattern.h
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>
#import <Hammer/HammerVisitor.h>

@class HammerChangeCell;

@protocol HammerDerivativePattern <HammerPattern, HammerVisitable>

@property (nonatomic, readonly, getter = isNullable) BOOL nullable;

@property (nonatomic, readonly, getter = isNull) BOOL null;

@property (nonatomic, readonly) NSString *prettyPrintedDescription;

-(void)updateRecursiveAttributes:(HammerChangeCell *)change;

@end

id<HammerDerivativePattern> HammerDerivativePattern(id<HammerPattern> pattern);
