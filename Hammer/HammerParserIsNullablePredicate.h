//  HammerParserIsNullablePredicate.h
//  Created by Rob Rix on 2012-09-29.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@class HammerParser;
@interface HammerParserIsNullablePredicate : NSObject

+(bool)isNullable:(HammerParser *)parser;

@end
