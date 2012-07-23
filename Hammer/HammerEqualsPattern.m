//  HammerEqualsPattern.m
//  Created by Rob Rix on 12-06-25.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerNullPattern.h"
#import "HammerEqualsPattern.h"
#import "HammerEmptyPattern.h"

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


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return [self match:object]?
		[HammerNullPattern pattern]
	:	[HammerEmptyPattern pattern];
}


-(BOOL)isEqualToEqualsPattern:(HammerEqualsPattern *)other {
	return
		[other isKindOfClass:self.class]
	&&	[_object isEqual:other.object];
}

-(BOOL)isEqual:(id)object {
	return [self isEqualToEqualsPattern:object];
}


-(NSString *)description {
	return [NSString stringWithFormat:@"<%@: %lx %@>", self.class, (NSUInteger)self, _object];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
