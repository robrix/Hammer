//  HammerConcatenationPattern.h
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>

@interface HammerConcatenationPattern : NSObject <HammerPattern>

+(id<HammerPattern>)patternWithLeftPattern:(id<HammerPattern>)left rightPattern:(id<HammerPattern>)right;

@property (nonatomic, readonly) id<HammerPattern> left;
@property (nonatomic, readonly) id<HammerPattern> right;

-(BOOL)isEqualToConcatenationPattern:(HammerConcatenationPattern *)other;

@end
