//  HammerNullReductionParser.h
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerParser.h>

@interface HammerNullReductionParser : HammerParser

+(instancetype)parserWithParseTrees:(NSSet *)trees;

@end
