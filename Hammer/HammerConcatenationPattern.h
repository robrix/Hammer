//  HammerConcatenationPattern.h
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>

@interface HammerConcatenationPattern : NSObject <HammerPattern>

+(id<HammerPattern>)patternWithPatterns:(NSArray *)patterns;
+(id<HammerPattern>)patternWithLeftPattern:(HammerLazyPattern)left rightPattern:(HammerLazyPattern)right;

-(BOOL)isEqualToConcatenationPattern:(HammerConcatenationPattern *)other;

@end
