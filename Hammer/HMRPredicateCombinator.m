//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRPredicateCombinator.h"

@implementation HMRPredicateCombinator

-(bool)evaluateWithObject:(id)object {
	return NO;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivative:(id<NSObject,NSCopying>)object {
	return [self evaluateWithObject:object]?
		HMRCaptureTree(object)
	:	HMRNone();
}

@end
