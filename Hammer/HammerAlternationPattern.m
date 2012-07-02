//  HammerAlternationPattern.m
//  Created by Rob Rix on 12-06-26.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationPattern.h"

@implementation HammerAlternationPattern {
	id<HammerPattern> _left;
	id<HammerPattern> _right;
}

+(id<HammerPattern>)patternWithLeftPattern:(id<HammerPattern>)left rightPattern:(id<HammerPattern>)right {
	if (HammerPatternIsNull(left)) return right;
	if (HammerPatternIsNull(right)) return left;
	HammerAlternationPattern *pattern = [self new];
	pattern->_left = left;
	pattern->_right = right;
	return pattern;
}


@synthesize left = _left;
@synthesize right = _right;


-(id<HammerPattern>)delta {
	return [HammerAlternationPattern patternWithLeftPattern:_left.delta rightPattern:_right.delta];
}

-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return [HammerAlternationPattern patternWithLeftPattern:[_left derivativeWithRespectTo:object] rightPattern:[_right derivativeWithRespectTo:object]];
}


-(BOOL)isEqualToAlternationPattern:(HammerAlternationPattern *)other {
	return
		[other isKindOfClass:self.class]
	&&	[_left isEqual:other.left]
	&&	[_right isEqual:other.right];
}

-(BOOL)isEqual:(id)object {
	return [self isEqualToAlternationPattern:object];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
