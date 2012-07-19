//  RXTraitDecorator.h
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "RXTrait.h"

@interface RXTraitDecorator : NSProxy

+(id)decorateObject:(id)object withTrait:(id<RXTrait>)trait;

@end
