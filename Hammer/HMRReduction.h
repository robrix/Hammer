//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRNonterminal.h>

@interface HMRReduction : HMRNonterminal

+(instancetype)reduce:(HMRCombinator *)combinator usingBlock:(HMRReductionBlock)block;

@property (readonly) HMRCombinator *combinator;
@property (readonly) NSString *functionDescription;
@property (readonly) HMRReductionBlock block;

-(instancetype)withFunctionDescription:(NSString *)functionDescription;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end

/// A reduction block that can be applied to ignore any produced parse trees.
extern HMRReductionBlock const HMRIgnoreReductionBlock;
