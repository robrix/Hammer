//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLeastFixedPoint.h"
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
	NSSet *_deforestation;
}

-(instancetype)init {
	if ((self = [super init])) {
		_derivativesByElements = [NSMutableDictionary new];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
	return nil;
}

-(NSSet *)deforest {
	return [NSSet set];
}


-(id<HMRCombinator>)memoizedDerivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
	return _derivativesByElements[element] ?: (_derivativesByElements[element] = [self derivativeWithRespectToElement:element]);
}

-(NSSet *)memoizedDeforest {
	return _deforestation ?: (_deforestation = HMRLeastFixedPoint([NSSet set], ^(NSSet *forest) {
		return _deforestation = [self deforest];
	}));
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}

@end
