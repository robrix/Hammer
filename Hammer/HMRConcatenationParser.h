//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParser.h"

@interface HMRConcatenationParser : HMRParser

+(instancetype)parserWithFirst:(HMRParser *)first second:(HMRParser *)second;

@property (readonly) HMRParser *first;
@property (readonly) HMRParser *second;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
