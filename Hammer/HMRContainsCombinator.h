//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRPredicateCombinator.h"
#import "HMRSet.h"

@interface HMRContainsCombinator : HMRPredicateCombinator

@property (readonly) id<HMRSet> set;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
