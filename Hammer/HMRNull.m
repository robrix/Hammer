//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMRNull.h"
#import "HMROnce.h"

@implementation HMRNull

+(instancetype)parser {
	return HMROnce((HMRNull *)[(id)self new]);
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id)element {
	return [HMREmpty parser];
}

@end
