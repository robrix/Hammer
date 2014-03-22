//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParser.h"

typedef HMRParser *(^HMRLazyParserBlock)();

@interface HMRLazyParser : HMRParser

+(instancetype)parserWithBlock:(HMRLazyParserBlock)block;

@property (readonly) HMRLazyParserBlock block;
@property (readonly) HMRParser *parser;

-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
