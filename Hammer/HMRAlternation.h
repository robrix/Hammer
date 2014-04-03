//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

@interface HMRAlternation : HMRParserCombinator

@property (readonly) id<HMRCombinator>left;
@property (readonly) id<HMRCombinator>right;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
