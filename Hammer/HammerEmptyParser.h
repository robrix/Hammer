//  HammerEmptyParser.h
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerParser.h>

// the language this parses is the empty set, ergo it parses nothing

@interface HammerEmptyParser : HammerParser

+(instancetype)parser;

@end
