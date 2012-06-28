//  HammerDerivativePattern.h
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>

@protocol HammerDerivativePattern <HammerPattern>

@property (nonatomic, readonly) id<HammerDerivativePattern> delta;
-(id<HammerDerivativePattern>)derivativeWithRespectTo:(id)object;

@property (nonatomic, readonly, getter = isNull) BOOL null;
@property (nonatomic, readonly, getter = isEmpty) BOOL empty;

@end

extern BOOL HammerMatchDerivativePattern(id<HammerDerivativePattern> pattern, NSEnumerator *sequence);