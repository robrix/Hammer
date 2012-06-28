//  HammerNullPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerNullPattern.h"

@implementation HammerNullPattern

+(HammerNullPattern *)pattern {
	static HammerNullPattern *pattern = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		pattern = [self new];
	});
	return pattern;
}


-(BOOL)match:(id)object {
	return NO;
}

-(id<HammerDerivativePattern>)delta {
	return self;
}

-(id<HammerDerivativePattern>)derivativeWithRespectTo:(id)object {
	return self;
}


-(BOOL)isNull {
	return YES;
}

-(BOOL)isEmpty {
	return NO;
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
