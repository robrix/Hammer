//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRNonterminal.h>

@interface HMRConcatenation : HMRNonterminal

@property (readonly) HMRCombinator *first;
@property (readonly) HMRCombinator *second;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
