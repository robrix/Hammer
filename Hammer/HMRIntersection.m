//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRIntersection.h"

@implementation HMRIntersection

+(instancetype)intersectLeft:(HMRCombinator *)left right:(HMRCombinator *)right {
	return [[self alloc] initWithLeft:left right:right];
}

-(instancetype)initWithLeft:(HMRCombinator *)left right:(HMRCombinator *)right {
	NSParameterAssert(left != nil);
	NSParameterAssert(right != nil);
	
	if ((self = [super init])) {
		_left = [left copy];
		_right = [right copy];
	}
	return self;
}

@end
