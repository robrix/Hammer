//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

typedef id(^HMRReductionBlock)(id);

@interface HMRReduction : HMRParserCombinator

+(instancetype)combinatorWithParser:(id<HMRCombinator>)parser block:(HMRReductionBlock)block;

@property (readonly) id<HMRCombinator>parser;
@property (readonly) HMRReductionBlock block;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
