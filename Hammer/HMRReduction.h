//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRNonterminal.h>

@interface HMRReduction : HMRNonterminal

@property (readonly) HMRCombinator *combinator;
@property (readonly) NSString *functionDescription;
@property (readonly) HMRReductionBlock block;

-(instancetype)withFunctionDescription:(NSString *)functionDescription;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
