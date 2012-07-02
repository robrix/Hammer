//  HammerConcatenationPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationPattern.h"
#import "HammerConcatenationPattern.h"
#import "HammerNullPattern.h"

@implementation HammerConcatenationPattern {
	id<HammerDerivativePattern> _left;
	id<HammerDerivativePattern> _right;
}

+(id<HammerDerivativePattern>)patternWithLeftPattern:(id<HammerDerivativePattern>)left rightPattern:(id<HammerDerivativePattern>)right {
	if (HammerPatternIsNull(left) || HammerPatternIsNull(right))
		return [HammerNullPattern pattern];
	if (HammerPatternIsEmpty(left))
		return right;
	if (HammerPatternIsEmpty(right))
		return left;
	HammerConcatenationPattern *pattern = [self new];
	pattern->_left = left;
	pattern->_right = right;
	return pattern;
}


@synthesize left = _left;
@synthesize right = _right;


-(BOOL)match:(id)object {
	return [_left match:object];
}

-(id<HammerDerivativePattern>)delta {
	return [HammerConcatenationPattern patternWithLeftPattern:_left.delta rightPattern:_right.delta];
}

-(id<HammerDerivativePattern>)derivativeWithRespectTo:(id)object {
	id<HammerDerivativePattern> left = [HammerConcatenationPattern patternWithLeftPattern:_left.delta rightPattern:[_right derivativeWithRespectTo:object]];
	id<HammerDerivativePattern> right = [HammerConcatenationPattern patternWithLeftPattern:[_left derivativeWithRespectTo:object] rightPattern:_right];
	return [HammerAlternationPattern patternWithLeftPattern:left rightPattern:right];
}


-(BOOL)isEqualToConcatenationPattern:(HammerConcatenationPattern *)other {
	return
		[other isKindOfClass:self.class]
	&&	[_left isEqual:other.left]
	&&	[_right isEqual:other.right];
}

-(BOOL)isEqual:(id)object {
	return [self isEqualToConcatenationPattern:object];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
