//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

@interface HMRLiteralCombinator : HMRParserCombinator

@property (readonly) id element;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end