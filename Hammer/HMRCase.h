//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDFilter.h>

@interface HMRCase : NSObject

+(id)match:(id)object withCases:(NSArray *)cases;

+(instancetype)case:(REDPredicateBlock)predicate then:(id(^)())block;

-(id)evaluateWithObject:(id)object;

@end


@interface NSObject (HMRCase)

-(id)hmr_matchPredicates:(NSArray *)predicates;

@end
