//  HammerPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerBlankPattern.h"
#import "HammerPattern.h"
#import "HammerNullPattern.h"
#import "HammerRepetitionPattern.h"

@interface HammerDerivativePatternDecorator : NSObject <HammerDerivativePattern>

+(id<HammerDerivativePattern>)derivativePatternWithPattern:(id<HammerPattern>)pattern;

@end

@implementation HammerDerivativePatternDecorator {
	id<HammerPattern> _pattern;
}

+(id<HammerDerivativePattern>)derivativePatternWithPattern:(id<HammerPattern>)pattern {
	HammerDerivativePatternDecorator *decorator = [self new];
	decorator->_pattern = pattern;
	return decorator;
}


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return [_pattern derivativeWithRespectTo:object];
}


-(id<HammerPattern>)delta {
	id<HammerPattern> delta = [HammerNullPattern pattern];
	if ([_pattern respondsToSelector:@selector(delta)])
		delta = [(id<HammerDerivativePattern>)_pattern delta];
	else if ([_pattern isKindOfClass:[HammerBlankPattern class]] || [_pattern isKindOfClass:[HammerRepetitionPattern class]])
		delta = [HammerBlankPattern pattern];
	return delta;
}


-(BOOL)isNull {
	return [_pattern isKindOfClass:[HammerNullPattern class]];
}

-(BOOL)isEmpty {
	return [_pattern isKindOfClass:[HammerBlankPattern class]];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end


id<HammerDerivativePattern> HammerDerivativePattern(id<HammerPattern> pattern) {
	return [pattern conformsToProtocol:@protocol(HammerDerivativePattern)]?
		(id<HammerDerivativePattern>)pattern
	:	[HammerDerivativePatternDecorator derivativePatternWithPattern:pattern];
}


BOOL HammerPatternMatchSequence(id<HammerPattern> _pattern, NSEnumerator *sequence) {
	id<HammerDerivativePattern> pattern = HammerDerivativePattern(_pattern);
	id term = [sequence nextObject];
	return term?
		HammerPatternMatchSequence([pattern derivativeWithRespectTo:term], sequence)
	:	HammerDerivativePattern(pattern.delta).isEmpty;
}

BOOL HammerPatternMatch(id<HammerPattern> pattern, id object) {
	return !HammerDerivativePattern([pattern derivativeWithRespectTo:object]).isNull;
}
