//  HammerDerivativePattern.h
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>
#import <Hammer/HammerVisitor.h>

@class HammerChangeCell;

@protocol HammerDerivativePattern <HammerPattern, HammerVisitable, NSCopying>

@property (nonatomic, readonly, getter = isNullable) BOOL nullable;

@property (nonatomic, readonly, getter = isEmpty) BOOL empty;

@property (nonatomic, readonly) NSString *prettyPrintedDescription;

@end

id<HammerDerivativePattern> HammerDerivativePattern(id<HammerPattern> pattern);
