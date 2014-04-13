//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDFilter.h>

@interface HMRCase : NSObject

+(instancetype)case:(REDPredicateBlock)predicate then:(id(^)())block;

-(id)evaluateWithObject:(id)object;

@end


/// Match \c subject against a series of \c cases.
id HMRMatch(id subject, NSArray *cases);
