//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmptyParser.h"
#import "HMROnce.h"
#import "HMRParser+Protected.h"

@implementation HMREmptyParser

+(instancetype)parser {
	return HMROnce((HMREmptyParser *)[(id)self new]);
}


#pragma mark HammerParser

-(HMRParser *)derivativeWithRespectToElement:(id)element {
	return self;
}

@end
