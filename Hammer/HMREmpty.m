//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMROnce.h"

@implementation HMREmpty

+(instancetype)empty {
	return HMROnce((HMREmpty *)[(id)self new]);
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)element {
	return self;
}


-(NSString *)describe {
	return @"∅";
}

@end
