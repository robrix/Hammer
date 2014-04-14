//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRPredicateCombinator.h"

@interface HMRBlockCombinator : HMRPredicateCombinator

-(instancetype)initWithBlock:(REDPredicateBlock)block;

@property (readonly) REDPredicateBlock block;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
