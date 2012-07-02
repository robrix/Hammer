//  HammerPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerBlankPattern.h"
#import "HammerPattern.h"
#import "HammerNullPattern.h"
#import "HammerRepetitionPattern.h"

BOOL HammerMatchDerivativePattern(id<HammerPattern> pattern, NSEnumerator *sequence) {
	id term = [sequence nextObject];
	return term?
		HammerMatchDerivativePattern([pattern derivativeWithRespectTo:term], sequence)
	:	HammerPatternIsEmpty(HammerPatternDelta(pattern));
}

BOOL HammerPatternIsNull(id<HammerPattern> pattern) {
	return [pattern isKindOfClass:[HammerNullPattern class]];
}

BOOL HammerPatternIsEmpty(id<HammerPattern> pattern) {
	return [pattern isKindOfClass:[HammerBlankPattern class]];
}

BOOL HammerPatternMatch(id<HammerPattern> pattern, id object) {
	return !HammerPatternIsNull([pattern derivativeWithRespectTo:object]);
}

id<HammerPattern> HammerPatternDelta(id<HammerPattern> pattern) {
	id<HammerPattern> delta = [HammerNullPattern pattern];
	if ([pattern respondsToSelector:@selector(delta)])
		delta = pattern.delta;
	else if ([pattern isKindOfClass:[HammerBlankPattern class]] || [pattern isKindOfClass:[HammerRepetitionPattern class]])
		delta = [HammerBlankPattern pattern];
	return delta;
}
