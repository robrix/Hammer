//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMROnce.h"

@implementation HMREmpty

#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return self;
}


-(NSString *)describe {
	return @"∅";
}

@end


id<HMRCombinator> HMRNone(void) {
	return HMROnce((HMREmpty *)[[HMREmpty class] new]);
}
