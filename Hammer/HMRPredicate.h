//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRCase <NSObject>

-(id)evaluateWithObject:(id)object;

@end


@protocol HMRPredicate <NSObject>

-(bool)matchObject:(id)object;

-(id<HMRCase>)then:(id(^)())block;

@end


@protocol HMRCombinator;
id<HMRCombinator> HMRBindCombinator(void);
