//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

typedef id<NSObject, NSCopying>(^HMRReductionBlock)(id<NSObject, NSCopying>);

@interface HMRReduction : HMRParserCombinator

@property (readonly) id<HMRCombinator> combinator;
@property (readonly) HMRReductionBlock block;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
