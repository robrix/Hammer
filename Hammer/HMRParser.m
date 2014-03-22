//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParser.h"

NSSet *HMRParseCollection(id<HMRCombinator> parser, id<NSFastEnumeration> collection) {
	for (id each in collection) {
		parser = [parser derivativeWithRespectToElement:each];
	}
	return [parser deforest];
}

id<HMRCombinator> HMRParseElement(id<HMRCombinator> parser, id element) {
	return element?
		[parser derivativeWithRespectToElement:element]
	:	nil; // ???
}


@implementation HMRParser

#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id)element {
	return nil;
}

-(NSSet *)deforest {
	return [NSSet set];
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}

@end
