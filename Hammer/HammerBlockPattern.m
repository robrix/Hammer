//  HammerBlockPattern.m
//  Created by Rob Rix on 12-06-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerBlockPattern.h"

@implementation HammerBlockPattern

@synthesize block;

-(BOOL)match:(id)sequence {
	return block(sequence);
}

@end
