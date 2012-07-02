//  HammerDerivativePattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerBlankPattern.h"
#import "HammerDerivativePattern.h"
#import "HammerNullPattern.h"
#import "HammerRepetitionPattern.h"

BOOL HammerMatchDerivativePattern(id<HammerDerivativePattern> pattern, NSEnumerator *sequence) {
	id term = [sequence nextObject];
	return term?
		HammerMatchDerivativePattern([pattern derivativeWithRespectTo:term], sequence)
	:	HammerPatternIsEmpty(HammerPatternDelta(pattern));
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

id<HammerDerivativePattern> HammerPatternDelta(id<HammerDerivativePattern> pattern) {
	id<HammerDerivativePattern> delta = [HammerNullPattern pattern];
	if ([pattern respondsToSelector:@selector(delta)])
		delta = pattern.delta;
	else if ([pattern isKindOfClass:[HammerBlankPattern class]] || [pattern isKindOfClass:[HammerRepetitionPattern class]])
		delta = [HammerBlankPattern pattern];
	return delta;
}
