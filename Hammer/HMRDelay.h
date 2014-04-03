//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

typedef id (^HMRDelayBlock)(void);

@interface HMRDelay : NSProxy <NSCopying>

-(instancetype)initWithBlock:(HMRDelayBlock)block class:(Class)class;

@property (readonly) id forced;

@end


@interface HMRDelayCombinator : HMRDelay

-(instancetype)initWithBlock:(HMRDelayBlock)block;
-(instancetype)initWithBlock:(HMRDelayBlock)block class:(Class)class UNAVAILABLE_ATTRIBUTE;

@end


#define HMRDelay(x) \
	((__typeof__(x))[[HMRDelayCombinator alloc] initWithBlock:^{ return (x); }])

#define HMRDelaySpecific(c, x) \
	((__typeof__(x))[[HMRDelay alloc] initWithBlock:^{ return (x); } class:(c)])
