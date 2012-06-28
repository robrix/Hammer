//  HammerRepetitionPattern.h
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerDerivativePattern.h>

@interface HammerRepetitionPattern : NSObject <HammerDerivativePattern>

+(id<HammerDerivativePattern>)patternWithPattern:(id<HammerDerivativePattern>)pattern;

@property (nonatomic, readonly) id<HammerDerivativePattern> pattern;

-(BOOL)isEqualToRepetitionPattern:(HammerRepetitionPattern *)other;

@end
