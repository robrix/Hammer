//  HammerParserDerivativeFunction.h
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@class HammerParser;
@interface HammerParserDerivativeFunction : NSObject

+(HammerParser *)derivatativeOfParser:(HammerParser *)parser withRespectToTerm:(id)term;

@end
