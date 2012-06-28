//  HammerEqualsPattern.h
//  Created by Rob Rix on 12-06-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerDerivativePattern.h>

@interface HammerEqualsPattern : NSObject <HammerDerivativePattern>

+(HammerEqualsPattern *)patternWithObject:(id)object;

@property (nonatomic, readonly) id object;

-(BOOL)isEqualToEqualsPattern:(HammerEqualsPattern *)other;

@end
