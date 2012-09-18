//  HammerParserCompactor.h
//  Created by Rob Rix on 2012-09-16.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@class HammerParser;
@interface HammerParserCompactor : NSObject

+(HammerParser *)compact:(HammerParser *)parser;

@end
