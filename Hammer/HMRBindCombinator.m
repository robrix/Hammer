//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRBindCombinator.h"
#import "HMRCase.h"
#import "HMROnce.h"

@implementation HMRBindCombinator

#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	NSMutableArray *bindings = [HMRCase bindings];
	[bindings addObject:object];
	return YES;
}


#pragma mark NSObject

-(NSString *)description {
	return @"↓";
}

@end


id HMRBind(void) {
	return HMROnce([HMRBindCombinator new]);
}
