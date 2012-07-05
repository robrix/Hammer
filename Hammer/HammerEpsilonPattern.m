//  HammerEpsilonPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEpsilonPattern.h"
#import "HammerNullPattern.h"

@implementation HammerEpsilonPattern

+(HammerEpsilonPattern *)pattern {
	static HammerEpsilonPattern *pattern = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		pattern = [self new];
	});
	return pattern;
}


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return [HammerNullPattern pattern];
}


-(BOOL)isEqual:(id)object {
	return [object isKindOfClass:self.class];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
