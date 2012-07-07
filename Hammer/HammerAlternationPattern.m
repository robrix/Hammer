//  HammerAlternationPattern.m
//  Created by Rob Rix on 12-06-26.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationPattern.h"
#import "HammerDerivativePattern.h"
#import "HammerEpsilonPattern.h"

@implementation HammerAlternationPattern {
	id<HammerDerivativePattern> _left;
	id<HammerDerivativePattern> _right;
	HammerLazyPattern _lazyLeft;
	HammerLazyPattern _lazyRight;
	BOOL _hasMemoizedNullability;
	BOOL _isNullable;
}

+(id<HammerPattern>)patternWithPatterns:(NSArray *)patterns {
	id<HammerPattern> pattern = nil;
	if (patterns.count == 0) {
		pattern = [HammerEpsilonPattern pattern];
	} else if (patterns.count == 1) {
		pattern = ((HammerLazyPattern)patterns.lastObject)();
	} else if (patterns.count == 2) {
		pattern = [self patternWithLeftPattern:[patterns objectAtIndex:0] rightPattern:[patterns objectAtIndex:1]];
	} else {
		pattern = [self patternWithLeftPattern:[patterns objectAtIndex:0] rightPattern:HammerDelayPattern([self patternWithPatterns:[patterns subarrayWithRange:NSMakeRange(1, patterns.count - 1)]])];
	}
	return pattern;
}

+(id<HammerPattern>)patternWithLeftPattern:(HammerLazyPattern)left rightPattern:(HammerLazyPattern)right {
	HammerAlternationPattern *pattern = [self new];
	pattern->_lazyLeft = left;
	pattern->_lazyRight = right;
	return pattern;
}


-(id<HammerDerivativePattern>)left {
	return _left ?: (_left = HammerDerivativePattern(_lazyLeft()));
}

-(id<HammerDerivativePattern>)right {
	return _right ?: (_right = HammerDerivativePattern(_lazyRight()));
}


-(BOOL)leastFixedPointNullability {
	_isNullable = NO;
	_hasMemoizedNullability = YES;
	BOOL previous = NO;
	while ((previous = self.left.isNullable || self.right.isNullable) != _isNullable) {
		_isNullable = previous;
	}
	return _isNullable;
}

-(BOOL)isNullable {
	return _hasMemoizedNullability?
		_isNullable
	:	self.leastFixedPointNullability;
}

-(BOOL)isNull {
	return self.left.isNull && self.right.isNull;
}

-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return [HammerAlternationPattern patternWithLeftPattern:HammerDelayPattern([self.left derivativeWithRespectTo:object]) rightPattern:HammerDelayPattern([self.right derivativeWithRespectTo:object])];
}


-(BOOL)isEqualToAlternationPattern:(HammerAlternationPattern *)other {
	return
		[other isKindOfClass:self.class]
	&&	[self.left isEqual:other.left]
	&&	[self.right isEqual:other.right];
}

-(BOOL)isEqual:(id)object {
	return [self isEqualToAlternationPattern:object];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
