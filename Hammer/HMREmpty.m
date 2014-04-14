//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMROnce.h"

@implementation HMREmpty

#pragma mark HMRCombinator

-(NSString *)describe {
	return @"∅";
}


-(NSUInteger)hash {
	return @"HMREmpty".hash;
}


-(instancetype)withName:(NSString *)name {
	return (self == HMRNone())?
		[[[self class] new] withName:name]
	:	[super withName:name];
}

@end


id<HMRCombinator> HMRNone(void) {
	return HMROnce((HMREmpty *)[[HMREmpty class] new]);
}
