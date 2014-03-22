//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLeastFixedPoint.h"
#import "HMRParserCombinator.h"

NSSet *HMRParseCollection(id<HMRCombinator> parser, id<NSFastEnumeration> collection) {
	for (id each in collection) {
		parser = [parser memoizedDerivativeWithRespectToElement:each];
	}
	return parser.deforestation;
}

id<HMRCombinator> HMRParseElement(id<HMRCombinator> parser, id<NSObject, NSCopying> element) {
	return element?
		[parser memoizedDerivativeWithRespectToElement:element]
	:	nil; // ???
}


@implementation HMRParserCombinator {
	NSMutableDictionary *_derivativesByElements;
	NSSet *_deforestation;
	id<HMRCombinator> _compaction;
	NSString *_description;
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

-(id<HMRCombinator>)memoizedDerivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
	return _derivativesByElements[element] ?: (_derivativesByElements[element] = [self derivativeWithRespectToElement:element].compaction);
}


-(NSSet *)deforest {
	return [NSSet set];
}

-(NSSet *)deforestation {
	return _deforestation ?: (_deforestation = HMRLeastFixedPoint([NSSet set], ^(NSSet *forest) {
		return _deforestation = [self deforest];
	}));
}


-(id<HMRCombinator>)compact {
	return self;
}

-(id<HMRCombinator>)compaction {
	return _compaction ?: (_compaction = [self compact]);
}


-(NSString *)describe {
	return super.description;
}

-(NSString *)description {
	return _description ?: (_description = [self describe]);
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}

@end
