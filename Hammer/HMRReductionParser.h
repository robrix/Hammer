//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParser.h"

typedef id(^HMRReductionBlock)(id);

@interface HMRReductionParser : HMRParser

+(instancetype)parserWithParser:(HMRParser *)parser block:(HMRReductionBlock)block;

@property (readonly) HMRParser *parser;
@property (readonly) HMRReductionBlock block;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
