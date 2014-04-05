//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRNonterminal.h"

@interface HMRRepetition : HMRNonterminal

@property (readonly) id<HMRCombinator> combinator;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
