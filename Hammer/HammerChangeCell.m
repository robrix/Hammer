//  HammerChangeCell.m
//  Created by Rob Rix on 2012-07-15.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerChangeCell.h"

@implementation HammerChangeCell

@synthesize changed = _changed;
@synthesize visitedPatterns = _visitedPatterns;

-(id)init {
	if ((self = [super init])) {
		_visitedPatterns = [NSMutableSet new];
	}
	return self;
}


-(BOOL)orWith:(BOOL)change {
	return _changed = _changed ?: change;
}

@end
