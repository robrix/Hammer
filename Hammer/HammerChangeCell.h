//  HammerChangeCell.h
//  Created by Rob Rix on 2012-07-15.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface HammerChangeCell : NSObject
@property (nonatomic, readonly) BOOL changed;
@property (nonatomic, readonly) NSMutableSet *visitedPatterns;

-(BOOL)orWith:(BOOL)change;

@end
