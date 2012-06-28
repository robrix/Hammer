//  HammerDerivativePattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerBlankPattern.h"
#import "HammerDerivativePattern.h"

BOOL HammerMatchDerivativePattern(id<HammerDerivativePattern> pattern, NSEnumerator *sequence) {
	id term = [sequence nextObject];
	return term?
		HammerMatchDerivativePattern([pattern derivativeWithRespectTo:term], sequence)
	:	pattern.isEmpty;
}
