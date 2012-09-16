//  HammerReductionParser.h
//  Created by Rob Rix on 2012-09-02.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerLaziness.h>
#import <Hammer/HammerParser.h>
#import <Hammer/HammerReductionFunction.h>


@interface HammerReductionParser : HammerParser

+(instancetype)parserWithParser:(HammerLazyParser)parser function:(HammerReductionFunction)function;

@property (nonatomic, readonly) HammerReductionFunction function;

@end
