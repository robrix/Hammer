//  HammerParserFormatter.h
//  Created by Rob Rix on 2012-08-19.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@class HammerParser;
@interface HammerParserFormatter : NSObject

+(NSString *)format:(HammerParser *)parser;

@end
