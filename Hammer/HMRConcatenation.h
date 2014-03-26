//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

@interface HMRConcatenation : HMRParserCombinator

+(instancetype)combinatorWithFirst:(id<HMRCombinator>)first second:(id<HMRCombinator>)second;

@property (readonly) id<HMRCombinator>first;
@property (readonly) id<HMRCombinator>second;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
