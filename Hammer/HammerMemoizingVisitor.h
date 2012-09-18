//  HammerMemoizingVisitor.h
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerVisitor.h>
#import <Hammer/HammerSymbolizer.h>

@interface HammerMemoizingVisitor : NSObject <HammerVisitor>

// the symbolizer is used when encountering nested instances
-(instancetype)initWithVisitor:(id<HammerVisitor>)visitor symbolizer:(id<HammerSymbolizer>)symbolizer;

@end
