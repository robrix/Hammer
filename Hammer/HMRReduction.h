//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRNonterminal.h"

typedef id<NSObject, NSCopying>(^HMRReductionBlock)(id<NSObject, NSCopying> each);

@interface HMRReduction : HMRNonterminal

@property (readonly) id<HMRCombinator> combinator;
@property (readonly) NSString *functionDescription;
@property (readonly) HMRReductionBlock block;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
