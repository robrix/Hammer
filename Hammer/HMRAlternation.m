//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMRLazyCombinator.h"

@implementation HMRAlternation

+(instancetype)combinatorWithLeft:(id<HMRCombinator>)left right:(id<HMRCombinator>)right {
	return [[self alloc] initWithLeft:left right:right];
}

-(instancetype)initWithLeft:(id<HMRCombinator>)left right:(id<HMRCombinator>)right {
	if ((self = [super init])) {
		_left = [left copyWithZone:NULL];
		_right = [right copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
	Class class = self.class;
	id<HMRCombinator> left = self.left;
	id<HMRCombinator> right = self.right;
	return [HMRLazyCombinator combinatorWithBlock:^{
		return [class combinatorWithLeft:[left memoizedDerivativeWithRespectToElement:element]
							   right:[right memoizedDerivativeWithRespectToElement:element]];
	}];
}


-(NSSet *)deforest {
	return [[self.left deforest] setByAddingObjectsFromSet:[self.right deforest]];
}

@end


id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right) {
	return [HMRAlternation combinatorWithLeft:left right:right];
}
