//  HammerRepetitionParser.h
//  Created by Rob Rix on 2012-08-04.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerParser.h>
#import <Hammer/HammerLaziness.h>

@interface HammerRepetitionParser : HammerParser

+(instancetype)parserWithParser:(HammerLazyParser)parser;

@end
