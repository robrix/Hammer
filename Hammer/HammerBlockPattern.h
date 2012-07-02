//  HammerBlockPattern.h
//  Created by Rob Rix on 12-06-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>

typedef BOOL (^HammerPatternBlock)(id object);

@interface HammerBlockPattern : NSObject <HammerPattern>

+(HammerBlockPattern *)patternWithBlock:(HammerPatternBlock)block;

@end
