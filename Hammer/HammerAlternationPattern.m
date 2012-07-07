//  HammerAlternationPattern.m
//  Created by Rob Rix on 12-06-26.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationPattern.h"
#import "HammerDerivativePattern.h"

@implementation HammerAlternationPattern {
	id<HammerDerivativePattern> _left;
	id<HammerDerivativePattern> _right;
	BOOL _hasMemoizedNullability;
	BOOL _isNullable;
}

+(id<HammerPattern>)patternWithLeftPattern:(id<HammerPattern>)_left rightPattern:(id<HammerPattern>)_right {
	id<HammerDerivativePattern> left = HammerDerivativePattern(_left);
	id<HammerDerivativePattern> right = HammerDerivativePattern(_right);
	if (left.isNull) return right;
	if (right.isNull) return left;
	HammerAlternationPattern *pattern = [self new];
	pattern->_left = left;
	pattern->_right = right;
	return pattern;
}


@synthesize left = _left;
@synthesize right = _right;


-(BOOL)leastFixedPointNullability {
	_isNullable = NO;
	_hasMemoizedNullability = YES;
	BOOL previous = NO;
	while ((previous = _left.isNullable || _right.isNullable) != _isNullable) {
		_isNullable = previous;
	}
	return _isNullable;
}

-(BOOL)isNullable {
	return _hasMemoizedNullability?
		_isNullable
	:	self.leastFixedPointNullability;
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
