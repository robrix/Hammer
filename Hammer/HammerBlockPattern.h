//  HammerBlockPattern.h
//  Created by Rob Rix on 12-06-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>

@interface HammerBlockPattern : NSObject <HammerPattern>

@property (copy) BOOL(^block)(id sequence);

@end
