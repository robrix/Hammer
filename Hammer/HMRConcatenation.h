//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRNonterminal.h>

@interface HMRConcatenation : HMRNonterminal

@property (readonly) id<HMRCombinator> first;
@property (readonly) id<HMRCombinator> second;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
