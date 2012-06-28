//  HammerRepetitionPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerBlankPattern.h"
#import "HammerConcatenationPattern.h"
#import "HammerRepetitionPattern.h"

@implementation HammerRepetitionPattern {
	id<HammerDerivativePattern> _pattern;
}

+(id<HammerDerivativePattern>)patternWithPattern:(id<HammerDerivativePattern>)pattern {
	if (pattern.isNull || pattern.isEmpty) return [HammerBlankPattern pattern];
	HammerRepetitionPattern *instance = [self new];
	instance->_pattern = pattern;
	return instance;
}


-(BOOL)match:(id)object {
	return [_pattern match:object] || YES;
}

-(id<HammerDerivativePattern>)delta {
	return [HammerBlankPattern pattern];
}

-(id<HammerDerivativePattern>)derivativeWithRespectTo:(id)object {
	return [HammerConcatenationPattern patternWithLeftPattern:[_pattern derivativeWithRespectTo:object] rightPattern:self];
}


-(BOOL)isNull {
	return NO;
}

-(BOOL)isEmpty {
	return NO;
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
