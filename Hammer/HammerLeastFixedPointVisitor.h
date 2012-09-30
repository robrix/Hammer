//  HammerLeastFixedPointVisitor.h
//  Created by Rob Rix on 2012-09-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerVisitor.h>

@interface HammerLeastFixedPointVisitor : NSObject <HammerVisitor>

-(instancetype)initWithBottom:(id)bottom visitor:(id<HammerVisitor>)visitor;

@property (readonly) id bottom;
@property (readonly) id<HammerVisitor> visitor;

@end
