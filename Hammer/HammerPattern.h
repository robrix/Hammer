//  HammerPattern.h
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HammerPattern <NSObject, NSCopying>

-(id<HammerPattern>)derivativeWithRespectTo:(id)object;

@optional
@property (nonatomic, readonly) id<HammerPattern> delta;

@end

extern BOOL HammerMatchDerivativePattern(id<HammerPattern> pattern, NSEnumerator *sequence);
extern BOOL HammerPatternIsNull(id<HammerPattern> pattern);
extern BOOL HammerPatternIsEmpty(id<HammerPattern> pattern);
extern BOOL HammerPatternMatch(id<HammerPattern> pattern, id object);
extern id<HammerPattern> HammerPatternDelta(id<HammerPattern> pattern);
