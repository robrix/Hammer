//  HammerConcatenationPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationPattern.h"
#import "HammerEpsilonPattern.h"
#import "HammerConcatenationPattern.h"
#import "HammerDerivativePattern.h"
#import "HammerList.h"
#import "HammerEmptyPattern.h"

@implementation HammerConcatenationPattern {
	id<HammerDerivativePattern> _left;
	id<HammerDerivativePattern> _right;
	HammerLazyPattern _lazyLeft;
	HammerLazyPattern _lazyRight;
}

+(id<HammerPattern>)patternWithPatterns:(NSArray *)patterns {
	HammerLazyPattern lazy = HammerArrayToList(patterns, 0, ^{
		return (id)HammerDelayPattern([HammerEpsilonPattern pattern]);
	}, ^(id (^pattern)()) {
		return (id)pattern;
	}, ^(id (^left)(), id (^right)()) {
		return (id)HammerDelayPattern([self patternWithLeftPattern:left rightPattern:right]);
	});
	return lazy();
}

+(id<HammerPattern>)patternWithLeftPattern:(HammerLazyPattern)left rightPattern:(HammerLazyPattern)right {
	HammerConcatenationPattern *pattern = [self new];
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


-(BOOL)isNullable {
	return self.left.isNullable && self.right.isNullable;
}

-(BOOL)isNull {
	return self.left.isNull || self.right.isNull;
}


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	HammerLazyPattern partial = HammerDelayPattern([HammerConcatenationPattern patternWithLeftPattern:HammerDelayPattern([self.left derivativeWithRespectTo:object]) rightPattern:_lazyRight]);
	return self.left.isNullable?
		[HammerAlternationPattern patternWithLeftPattern:HammerDelayPattern([self.right derivativeWithRespectTo:object]) rightPattern:partial]
	:	partial();
}


-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	id childrenResults = nil;
	if ([visitor visitObject:self])  {
		id leftResult = [self.left acceptVisitor:visitor];
		id rightResult = [self.right acceptVisitor:visitor];
		childrenResults = (leftResult || rightResult)?
			[NSArray arrayWithObjects:leftResult, rightResult, nil]
		:	[NSArray array];
	}
	return [visitor leaveObject:self withVisitedChildren:childrenResults];
}


-(BOOL)isEqualToConcatenationPattern:(HammerConcatenationPattern *)other {
	return
		[other isKindOfClass:self.class]
	&&	[self.left isEqual:other.left]
	&&	[self.right isEqual:other.right];
}

-(BOOL)isEqual:(id)object {
	return [self isEqualToConcatenationPattern:object];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
