//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRCombinator.h>

@interface HMRNonterminal : HMRCombinator

#pragma mark Subclass responsibilities

-(HMRCombinator *)deriveWithRespectToObject:(id<NSObject, NSCopying>)object;

-(NSSet *)reduceParseForest;

/// Produce a deeply compacted representation of the receiver.
-(HMRCombinator *)compact;

-(NSString *)describe;

-(NSUInteger)computeHash;

-(id)reduce:(id)initial usingBlock:(REDReducingBlock)block;


#pragma mark Unavailable

+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
