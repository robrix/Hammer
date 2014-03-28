//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

@interface HMRLiteralCombinator : HMRParserCombinator

+(instancetype)combinatorWithObject:(id<NSObject, NSCopying>)object;

@property (readonly) id<NSObject, NSCopying> object;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end