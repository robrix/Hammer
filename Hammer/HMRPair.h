//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@interface HMRPair : NSObject <NSCopying, REDReducible>

@property (readonly) id first;
@property (readonly) id rest;

@end


HMRPair *HMRCons(id first, id rest);
HMRPair *HMRList(id first, ...) NS_REQUIRES_NIL_TERMINATION;
