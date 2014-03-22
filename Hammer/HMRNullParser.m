//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmptyParser.h"
#import "HMRNullParser.h"
#import "HMROnce.h"
#import "HMRParser+Protected.h"

@implementation HMRNullParser

+(instancetype)parser {
	return HMROnce((HMRNullParser *)[(id)self new]);
}


#pragma mark HammerParser

-(bool)isNull {
	return YES;
}

-(bool)isNullable {
	return YES;
}


-(HMRParser *)derivativeWithRespectToElement:(id)element {
	return [HMREmptyParser parser];
}

@end
