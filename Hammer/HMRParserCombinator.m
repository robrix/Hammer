//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

NSSet *HMRParseCollection(id<HMRCombinator> parser, id<NSFastEnumeration> collection) {
	for (id each in collection) {
		parser = [parser derivativeWithRespectToElement:each];
	}
	return [parser deforest];
}

id<HMRCombinator> HMRParseElement(id<HMRCombinator> parser, id<NSObject, NSCopying> element) {
	return element?
		[parser derivativeWithRespectToElement:element]
	:	nil; // ???
}


@implementation HMRParserCombinator {
	NSDictionary *_derivativesByElements;
}

#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
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
