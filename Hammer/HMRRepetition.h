//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRNonterminal.h>

@interface HMRRepetition : HMRNonterminal

+(instancetype)repeat:(HMRCombinator *)combinator;

@property (readonly) HMRCombinator *combinator;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
