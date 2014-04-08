//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRNonterminal.h"
#import <Reducers/REDMap.h>

@interface HMRReduction : HMRNonterminal

@property (readonly) id<HMRCombinator> combinator;
@property (readonly) REDMapBlock block;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
