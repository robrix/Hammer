//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRNonterminal.h>

@interface HMRAlternation : HMRNonterminal

@property (readonly) id<HMRCombinator>left;
@property (readonly) id<HMRCombinator>right;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
