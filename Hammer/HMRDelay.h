//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

typedef id (^HMRDelayBlock)(void);

@interface HMRDelay : NSProxy <NSCopying>

-(instancetype)initWithClass:(Class)class block:(HMRDelayBlock)block;

@property (readonly, getter = isForcing) bool forcing;
@property (readonly) id forced;

@end

#define HMRDelaySpecific(c, x) \
	((__typeof__(x))[[HMRDelay alloc] initWithClass:(c) block:^{ return (x); }])
