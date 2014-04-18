//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAnyCombinator.h"
#import "HMROnce.h"

@implementation HMRAnyCombinator

#pragma mark HMRCombinator

-(NSString *)describe {
	return @".";
}


#pragma mark HMRPredicateCombinator

-(bool)evaluateWithObject:(id)object {
	return YES;
}


#pragma mark NSObject

-(NSUInteger)hash {
	return @"HMRAny".hash;
}

@end


id HMRAny(void) {
	return HMROnce([HMRAnyCombinator new]);
}
