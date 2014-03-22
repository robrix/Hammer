//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRParser.h"

@interface HMRAlternationParser : HMRParser

+(instancetype)parserWithLeft:(HMRParser *)left right:(HMRParser *)right;

@property (readonly) HMRParser *left;
@property (readonly) HMRParser *right;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
