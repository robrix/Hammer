//  HammerDerivativePattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerBlankPattern.h"
#import "HammerDerivativePattern.h"
#import "HammerNullPattern.h"

BOOL HammerMatchDerivativePattern(id<HammerDerivativePattern> pattern, NSEnumerator *sequence) {
	id term = [sequence nextObject];
	return term?
		HammerMatchDerivativePattern([pattern derivativeWithRespectTo:term], sequence)
	:	HammerPatternIsEmpty(pattern.delta);
}

BOOL HammerPatternIsNull(id<HammerDerivativePattern> pattern) {
	return [pattern isKindOfClass:[HammerNullPattern class]];
}

BOOL HammerPatternIsEmpty(id<HammerDerivativePattern> pattern) {
	return [pattern isKindOfClass:[HammerBlankPattern class]];
}

BOOL HammerPatternMatch(id<HammerDerivativePattern> pattern, id object) {
	return !HammerPatternIsNull([pattern derivativeWithRespectTo:object]);
}
