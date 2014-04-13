//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDFilter.h>
#import <Hammer/HMRPredicate.h>

@interface HMRCase : NSObject <HMRCase>

+(instancetype)caseWithPredicate:(id<HMRPredicate>)predicate block:(id (^)())block;

-(id)evaluateWithObject:(id)object;

@end

