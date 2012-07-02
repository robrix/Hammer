//  HammerConcatenationPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationPattern.h"
#import "HammerConcatenationPattern.h"
#import "HammerNullPattern.h"

@implementation HammerConcatenationPattern {
	id<HammerPattern> _left;
	id<HammerPattern> _right;
}

+(id<HammerPattern>)patternWithLeftPattern:(id<HammerPattern>)left rightPattern:(id<HammerPattern>)right {
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


-(id<HammerPattern>)delta {
	return [HammerConcatenationPattern patternWithLeftPattern:HammerPatternDelta(_left) rightPattern:HammerPatternDelta(_right)];
}

-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	id<HammerPattern> left = [HammerConcatenationPattern patternWithLeftPattern:HammerPatternDelta(_left) rightPattern:[_right derivativeWithRespectTo:object]];
	id<HammerPattern> right = [HammerConcatenationPattern patternWithLeftPattern:[_left derivativeWithRespectTo:object] rightPattern:_right];
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
