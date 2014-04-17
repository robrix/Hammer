//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRPredicateCombinator.h"

@implementation HMRPredicateCombinator

-(bool)evaluateWithObject:(id)object {
	return NO;
}


#pragma mark HMRCombinator

-(HMRCombinator *)derivative:(id<NSObject,NSCopying>)object {
	return [self evaluateWithObject:object]?
		[HMRCombinator captureTree:object]
	:	[HMRCombinator empty];
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return [self evaluateWithObject:object];
}

@end
