//  HammerParserIsEqualPredicate.h
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@class HammerParser;
@interface HammerParserIsEqualPredicate : NSObject

+(bool)isParser:(HammerParser *)a equalToParser:(HammerParser *)b;

@end
