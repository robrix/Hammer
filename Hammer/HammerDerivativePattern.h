//  HammerDerivativePattern.h
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>

@protocol HammerDerivativePattern <HammerPattern>

@property (nonatomic, readonly, getter = isNullable) BOOL nullable;

@property (nonatomic, readonly, getter = isNull) BOOL null;
@property (nonatomic, readonly, getter = isEpsilon) BOOL epsilon;

@end

id<HammerDerivativePattern> HammerDerivativePattern(id<HammerPattern> pattern);
