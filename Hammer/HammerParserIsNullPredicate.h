//  HammerParserIsNullPredicate.h
//  Created by Rob Rix on 2012-09-20.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@class HammerParser;
@interface HammerParserIsNullPredicate : NSObject

+(bool)isNull:(HammerParser *)parser;

@end
