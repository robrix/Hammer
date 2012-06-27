//  HammerBlockPattern.m
//  Created by Rob Rix on 12-06-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerBlockPattern.h"

@implementation HammerBlockPattern {
	HammerPatternBlock _block;
}

+(HammerBlockPattern *)patternWithBlock:(HammerPatternBlock)block {
	HammerBlockPattern *pattern = [self new];
	pattern->_block = [block copy];
	return pattern;
}

-(BOOL)match:(id)object {
	return _block(object);
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
