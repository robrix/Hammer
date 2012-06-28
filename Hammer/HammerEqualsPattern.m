//  HammerEqualsPattern.m
//  Created by Rob Rix on 12-06-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerBlankPattern.h"
#import "HammerEqualsPattern.h"
#import "HammerNullPattern.h"

@implementation HammerEqualsPattern {
	id _object;
}

+(HammerEqualsPattern *)patternWithObject:(id)object {
	HammerEqualsPattern *pattern = [self new];
	pattern->_object = object;
	return pattern;
}

-(BOOL)match:(id)object {
	return
		(object == _object)
	||	[object isEqual:_object];
}

-(id<HammerDerivativePattern>)delta {
	return [HammerNullPattern pattern];
}

-(id<HammerDerivativePattern>)derivativeWithRespectTo:(id)object {
	return [self match:object]?
		[HammerBlankPattern pattern]
	:	[HammerNullPattern pattern];
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
