//  HammerConcatenationPattern.h
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerDerivativePattern.h>

@interface HammerConcatenationPattern : NSObject <HammerDerivativePattern>

+(id<HammerDerivativePattern>)patternWithLeftPattern:(id<HammerDerivativePattern>)left rightPattern:(id<HammerDerivativePattern>)right;

@property (nonatomic, readonly) id<HammerDerivativePattern> left;
@property (nonatomic, readonly) id<HammerDerivativePattern> right;

-(BOOL)isEqualToConcatenationPattern:(HammerConcatenationPattern *)other;

@end
