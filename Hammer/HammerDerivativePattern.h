//  HammerDerivativePattern.h
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HammerDerivativePattern <NSObject, NSCopying>

-(id<HammerDerivativePattern>)derivativeWithRespectTo:(id)object;

@optional
@property (nonatomic, readonly) id<HammerDerivativePattern> delta;

@end

extern BOOL HammerMatchDerivativePattern(id<HammerDerivativePattern> pattern, NSEnumerator *sequence);
extern BOOL HammerPatternIsNull(id<HammerDerivativePattern> pattern);
extern BOOL HammerPatternIsEmpty(id<HammerDerivativePattern> pattern);
extern BOOL HammerPatternMatch(id<HammerDerivativePattern> pattern, id object);
extern id<HammerDerivativePattern> HammerPatternDelta(id<HammerDerivativePattern> pattern);
