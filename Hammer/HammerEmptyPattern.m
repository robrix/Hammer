//  HammerEmptyPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEmptyPattern.h"

@implementation HammerEmptyPattern

+(HammerEmptyPattern *)pattern {
	static HammerEmptyPattern *pattern = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		pattern = [self new];
	});
	return pattern;
}


-(BOOL)isEmpty {
	return YES;
}


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return self;
}


-(BOOL)isEqual:(id)object {
	return [object isKindOfClass:self.class];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
