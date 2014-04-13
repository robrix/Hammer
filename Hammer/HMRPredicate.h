//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRCase <NSObject>

-(id)evaluateWithObject:(id)object;

@end


@protocol HMRPredicate <NSObject>

-(bool)matchObject:(id)object;

-(id<HMRCase>)then:(id(^)())block;

@end


/// Match \c subject against a series of \c cases.
id HMRMatch(id subject, NSArray *cases);


@protocol HMRCombinator;
id HMRBindCombinator(void);
