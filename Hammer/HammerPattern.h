//  HammerPattern.h
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerVisitor.h>

@protocol HammerPattern <NSObject>

-(id<HammerPattern>)derivativeWithRespectTo:(id)object;

@end

typedef id<HammerPattern> (^HammerLazyPattern)();
#define HammerDelayPattern(p) ^{ return (p); }

extern BOOL HammerPatternMatchSequence(id<HammerPattern> pattern, NSEnumerator *sequence);
extern BOOL HammerPatternMatch(id<HammerPattern> pattern, id object);

extern id HammerPatternVisitGraph(id<HammerPattern> pattern, id<HammerVisitor> visitor);
extern NSString *HammerPatternDescription(id<HammerPattern> pattern);