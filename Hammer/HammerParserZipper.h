//  HammerParserZipper.h
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface HammerParserZipper : NSObject

// maps an array of parsers into a sequence of block calls, recursively

+(void)zip:(NSArray *)parsers block:(void(^)(NSArray *parsers, bool *stop))block;

@end
