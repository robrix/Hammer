//  HammerEqualsPattern.m
//  Created by Rob Rix on 12-06-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEqualsPattern.h"

@implementation HammerEqualsPattern {
	id _object;
}

+(HammerEqualsPattern *)patternWithObject:(id)object {
	HammerEqualsPattern *pattern = [self new];
	pattern->_object = object;
	return pattern;
}

-(BOOL)match:(id)object {
	return
		(object == _object)
	||	[object isEqual:_object];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
