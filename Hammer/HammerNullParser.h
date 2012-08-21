//  HammerNullParser.h
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerParser.h>

// the language this parses is the set containing the empty string, ergo it parses at the end of the input

@interface HammerNullParser : HammerParser

+(instancetype)parser;

@end
