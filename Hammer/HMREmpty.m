//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMROnce.h"

@implementation HMREmpty

+(instancetype)parser {
	return HMROnce((HMREmpty *)[(id)self new]);
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id)element {
	return self;
}

@end
