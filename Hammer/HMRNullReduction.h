//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParserCombinator.h"

@interface HMRNullReduction : HMRParserCombinator

+(instancetype)combinatorWithElement:(id<NSObject, NSCopying>)element;

@property (readonly) NSSet *parseForest;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
