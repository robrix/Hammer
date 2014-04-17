//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRBindCombinator.h"
#import "HMRCase.h"
#import "HMROnce.h"

@implementation HMRBindCombinator

#pragma mark HMRCombinator

-(NSString *)describe {
	return @"↓";
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	[HMRCase.bindings addObject:object];
	return YES;
}


#pragma mark NSObject

-(NSUInteger)hash {
	return @"HMRBind".hash;
}

@end


id HMRBind(void) {
	return HMROnce([HMRBindCombinator new]);
}
