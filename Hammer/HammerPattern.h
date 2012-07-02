//  HammerPattern.h
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HammerPattern <NSObject, NSCopying>

-(id<HammerPattern>)derivativeWithRespectTo:(id)object;

@end


extern BOOL HammerPatternMatchSequence(id<HammerPattern> pattern, NSEnumerator *sequence);
extern BOOL HammerPatternMatch(id<HammerPattern> pattern, id object);
