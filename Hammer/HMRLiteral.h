//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRPredicateCombinator.h"

@interface HMRLiteral : HMRPredicateCombinator

+(instancetype)literal:(id)object;

@property (readonly) id<NSObject, NSCopying> object;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
