//  HammerConcatenationPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationPattern.h"
#import "HammerBlankPattern.h"
#import "HammerConcatenationPattern.h"
#import "HammerDerivativePattern.h"
#import "HammerNullPattern.h"

@implementation HammerConcatenationPattern {
	id<HammerDerivativePattern> _left;
	id<HammerDerivativePattern> _right;
}

+(id<HammerPattern>)patternWithLeftPattern:(id<HammerPattern>)_left rightPattern:(id<HammerPattern>)_right {
	id<HammerDerivativePattern> left = HammerDerivativePattern(_left);
	id<HammerDerivativePattern> right = HammerDerivativePattern(_right);
	if (left.isNull || right.isNull)
		return [HammerNullPattern pattern];
	if (left.matchesAtEnd)
		return right;
	if (right.matchesAtEnd)
		return left;
	HammerConcatenationPattern *pattern = [self new];
	pattern->_left = left;
	pattern->_right = right;
	return pattern;
}


@synthesize left = _left;
@synthesize right = _right;


-(BOOL)isNullable {
	return _left.isNullable && _right.isNullable;
}

-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	id<HammerPattern> partial = [HammerConcatenationPattern patternWithLeftPattern:[_left derivativeWithRespectTo:object] rightPattern:_right];
	return _left.isNullable?
		[HammerAlternationPattern patternWithLeftPattern:partial rightPattern:_right]
	:	partial;
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
