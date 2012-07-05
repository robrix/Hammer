//  HammerPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerDerivativePattern.h"
#import "HammerPattern.h"

BOOL HammerPatternMatchSequence(id<HammerPattern> _pattern, NSEnumerator *sequence) {
	id<HammerDerivativePattern> pattern = HammerDerivativePattern(_pattern);
	id term = [sequence nextObject];
	return term?
		HammerPatternMatchSequence([pattern derivativeWithRespectTo:term], sequence)
	:	pattern.isNullable;
}

BOOL HammerPatternMatch(id<HammerPattern> pattern, id object) {
	return !HammerDerivativePattern([pattern derivativeWithRespectTo:object]).isNull;
}
