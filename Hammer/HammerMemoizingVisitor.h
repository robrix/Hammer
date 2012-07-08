//  HammerMemoizingVisitor.h
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerVisitor.h>

@interface HammerMemoizingVisitor : NSObject <HammerVisitor>

-(instancetype)initWithVisitor:(id<HammerVisitor>)visitor;

@end
