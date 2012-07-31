//  HammerBlockPattern.m
//  Created by Rob Rix on 12-06-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerNullPattern.h"
#import "HammerBlockPattern.h"
#import "HammerEmptyPattern.h"

@implementation HammerBlockPattern {
	HammerPatternBlock _block;
}

+(HammerBlockPattern *)patternWithBlock:(HammerPatternBlock)block {
	HammerBlockPattern *pattern = [self new];
	pattern->_block = [block copy];
	return pattern;
}


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return _block(object)?
		[HammerNullPattern pattern]
	:	[HammerEmptyPattern pattern];
}

@end
