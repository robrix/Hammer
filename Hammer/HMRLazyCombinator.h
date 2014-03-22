//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

typedef id<HMRCombinator>(^HMRLazyCombinatorBlock)();

@interface HMRLazyCombinator : HMRParserCombinator

+(instancetype)combinatorWithBlock:(HMRLazyCombinatorBlock)block;

@property (readonly) HMRLazyCombinatorBlock block;
@property (readonly) id<HMRCombinator>parser;

-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
