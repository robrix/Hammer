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


@synthesize object = _object;


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


-(BOOL)isEqualToEqualsPattern:(HammerEqualsPattern *)other {
	return
		[other isKindOfClass:self.class]
	&&	[_object isEqual:other.object];
}

-(BOOL)isEqual:(id)object {
	return [self isEqualToEqualsPattern:object];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
