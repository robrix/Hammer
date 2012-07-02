//  HammerRepetitionPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerBlankPattern.h"
#import "HammerConcatenationPattern.h"
#import "HammerRepetitionPattern.h"

@implementation HammerRepetitionPattern {
	id<HammerDerivativePattern> _pattern;
}

+(id<HammerPattern>)patternWithPattern:(id<HammerPattern>)_pattern {
	id<HammerDerivativePattern> pattern = HammerDerivativePattern(_pattern);
	if (pattern.isNull || pattern.matchesAtEnd) return [HammerBlankPattern pattern];
	HammerRepetitionPattern *instance = [self new];
	instance->_pattern = pattern;
	return instance;
}


@synthesize pattern = _pattern;


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return [HammerConcatenationPattern patternWithLeftPattern:[_pattern derivativeWithRespectTo:object] rightPattern:self];
}


-(BOOL)isEqualToRepetitionPattern:(HammerRepetitionPattern *)other {
	return
		[other isKindOfClass:self.class]
	&&	[_pattern isEqual:other.pattern];
}

-(BOOL)isEqual:(id)object {
	return [self isEqualToRepetitionPattern:object];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
