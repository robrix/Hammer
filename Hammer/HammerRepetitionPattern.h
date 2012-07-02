//  HammerRepetitionPattern.h
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>

@interface HammerRepetitionPattern : NSObject <HammerPattern>

+(id<HammerPattern>)patternWithPattern:(id<HammerPattern>)pattern;

@property (nonatomic, readonly) id<HammerPattern> pattern;

-(BOOL)isEqualToRepetitionPattern:(HammerRepetitionPattern *)other;

@end
