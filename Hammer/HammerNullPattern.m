//  HammerNullPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerNullPattern.h"
#import "HammerEmptyPattern.h"

@implementation HammerNullPattern

+(HammerNullPattern *)pattern {
	static HammerNullPattern *pattern = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		pattern = [self new];
	});
	return pattern;
}


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return [HammerEmptyPattern pattern];
}


-(BOOL)isNullable {
	return YES;
}


-(BOOL)isEqual:(id)object {
	return [object isKindOfClass:self.class];
}

@end
