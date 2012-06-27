//  HammerPattern.h
//  Created by Rob Rix on 12-06-24.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HammerPattern <NSObject, NSCopying>

-(BOOL)match:(id)object;

@end
