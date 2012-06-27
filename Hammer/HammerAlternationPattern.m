//  HammerAlternationPattern.m
//  Created by Rob Rix on 12-06-26.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationPattern.h"

@implementation HammerAlternationPattern {
	NSArray *_patterns;
}

+(HammerAlternationPattern *)patternWithAlternatives:(NSArray *)patterns {
	HammerAlternationPattern *pattern = [self new];
	pattern->_patterns = patterns;
	return pattern;
}


-(BOOL)match:(id)object {
	BOOL matched = NO;
	for (id<HammerPattern> pattern in _patterns) {
		if ((matched = [pattern match:object]))
			break;
	}
	return matched;
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
