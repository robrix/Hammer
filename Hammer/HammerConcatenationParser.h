//  HammerConcatenationParser.h
//  Created by Rob Rix on 2012-07-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerParser.h>
#import <Hammer/HammerLaziness.h>

@interface HammerConcatenationParser : HammerParser

+(instancetype)parserWithFirst:(HammerLazyParser)first second:(HammerLazyParser)second;

@property (nonatomic, readonly) HammerParser *first;
@property (nonatomic, readonly) HammerParser *second;

@end
