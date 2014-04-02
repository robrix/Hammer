//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

typedef id (^HMRDelayBlock)(void);

@interface HMRDelay : NSProxy <NSCopying>

+(id)delay:(HMRDelayBlock)block;

@property (readonly) id forced;

@end

#define HMRDelay(x) \
	[HMRDelay delay:^{ return (x); }]
