//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParser+Protected.h"

@implementation HMRParser

-(bool)isNullable {
	return NO;
}

-(bool)isNull {
	return NO;
}

-(bool)isEmpty {
	return YES;
}


-(HMRParser *)parse:(id)element {
	return nil;
}

-(HMRParser *)derivativeWithRespectToElement:(id)element {
	return nil;
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}

@end
