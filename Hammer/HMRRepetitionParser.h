//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParser.h"

@interface HMRRepetitionParser : HMRParser

+(instancetype)parserWithParser:(HMRParser *)parser;

@property (readonly) HMRParser *parser;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
