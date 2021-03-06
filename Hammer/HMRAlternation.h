//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRNonterminal.h>

@interface HMRAlternation : HMRNonterminal

+(instancetype)alternateLeft:(HMRCombinator *)left right:(HMRCombinator *)right;

@property (readonly) HMRCombinator *left;
@property (readonly) HMRCombinator *right;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
