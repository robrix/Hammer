//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRCombinator.h>

@interface HMRNonterminal : NSObject <HMRCombinator>

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object;

-(bool)computeNullability;

-(bool)computeCyclic;

-(NSSet *)reduceParseForest;

/// Produce a deeply compacted representation of the receiver.
-(id<HMRCombinator>)compact;

-(NSString *)describe;
-(NSSet *)prettyPrint;

+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
