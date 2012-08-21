//  HammerConcatenationParser.h
//  Created by Rob Rix on 2012-07-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerParser.h>

@interface HammerConcatenationParser : HammerParser

+(instancetype)parserWithLeft:(HammerLazyParser)left right:(HammerLazyParser)right;

@end
