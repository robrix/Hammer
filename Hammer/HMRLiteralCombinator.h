//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

@interface HMRLiteralCombinator : HMRParserCombinator

+(instancetype)combinatorWithElement:(id<NSObject, NSCopying>)element;

@property (readonly) id<NSObject, NSCopying> element;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
