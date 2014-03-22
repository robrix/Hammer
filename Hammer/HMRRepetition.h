//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

@interface HMRRepetition : HMRParserCombinator

+(instancetype)combinatorWithParser:(id<HMRCombinator>)parser;

@property (readonly) id<HMRCombinator>parser;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
