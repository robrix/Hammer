//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParser.h"

@interface HMRNullReductionParser : HMRParser

+(instancetype)parserWithElement:(id)element;

@property (readonly) NSSet *parseForest;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
