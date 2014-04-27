//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRPredicateCombinator.h"
#import "HMRSet.h"

@interface HMRContainment : HMRPredicateCombinator

+(instancetype)containedIn:(id<HMRSet>)set;

@property (readonly) id<HMRSet> set;


/// A dictionary of named character sets keyed by their names.
+(NSDictionary *)characterSetsByName;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
