//  HammerAlternationPattern.h
//  Created by Rob Rix on 12-06-26.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>

@interface HammerAlternationPattern : NSObject <HammerPattern>

+(HammerAlternationPattern *)patternWithAlternatives:(NSArray *)patterns;

@end
