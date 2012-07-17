//  HammerPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerDerivativePattern.h"
#import "HammerIdentitySymbolizer.h"
#import "HammerMemoizingVisitor.h"
#import "HammerPattern.h"
#import "HammerPatternDescriptionVisitor.h"

BOOL HammerPatternMatchSequence(id<HammerPattern> _pattern, NSEnumerator *sequence) {
	id<HammerDerivativePattern> pattern = HammerDerivativePattern(_pattern);
	id term = [sequence nextObject];
	NSLog(@"%@", HammerPatternDescription(pattern));
	return term?
		HammerPatternMatchSequence([pattern derivativeWithRespectTo:term], sequence)
	:	pattern.isNullable;
}

BOOL HammerPatternMatch(id<HammerPattern> pattern, id object) {
	return !HammerDerivativePattern([pattern derivativeWithRespectTo:object]).isNull;
}


id HammerPatternVisitGraph(id<HammerPattern> pattern, id<HammerVisitor> visitor) {
	HammerMemoizingVisitor *memoizingVisitor = [[HammerMemoizingVisitor alloc] initWithVisitor:visitor symbolizer:[HammerIdentitySymbolizer symbolizer]];
	return [HammerDerivativePattern(pattern) acceptVisitor:memoizingVisitor];
}

NSString *HammerPatternDescription(id<HammerPattern> pattern) {
	return HammerPatternVisitGraph(pattern, [HammerPatternDescriptionVisitor new]);
}