//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

typedef id<HMRCombinator>(^HMRLazyCombinatorBlock)();

@interface HMRLazyCombinator : HMRParserCombinator

@property (readonly) HMRLazyCombinatorBlock block;
@property (readonly) id<HMRCombinator> combinator;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
