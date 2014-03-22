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


-(NSSet *)parseCollection:(id<NSFastEnumeration>)enumerator {
	HMRParser *parser = self;
	for (id each in enumerator) {
		parser = [parser derivativeWithRespectToElement:each];
	}
	return [parser parseNull];
}

-(HMRParser *)parse:(id)element {
	return element?
		[self derivativeWithRespectToElement:element]
	:	nil;
}


-(HMRParser *)derivativeWithRespectToElement:(id)element {
	return nil;
}


-(NSSet *)parseNull {
	return [NSSet set];
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}

@end
