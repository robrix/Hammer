//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

NSSet *HMRParseCollection(id<HMRCombinator> parser, id<NSFastEnumeration> collection) {
	for (id each in collection) {
		parser = [parser memoizedDerivativeWithRespectToElement:each];
	}
	return [parser deforest];
}

id<HMRCombinator> HMRParseElement(id<HMRCombinator> parser, id<NSObject, NSCopying> element) {
	return element?
		[parser memoizedDerivativeWithRespectToElement:element]
	:	nil; // ???
}


@implementation HMRParserCombinator {
	NSMutableDictionary *_derivativesByElements;
}

-(instancetype)init {
	if ((self = [super init])) {
		_derivativesByElements = [NSMutableDictionary new];
	}
	return self;
}


-(id<HMRCombinator>)memoizedDerivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
	return _derivativesByElements[element] ?: (_derivativesByElements[element] = [self derivativeWithRespectToElement:element]);
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
