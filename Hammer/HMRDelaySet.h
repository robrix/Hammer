//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@interface HMRDelaySet : NSSet

+(instancetype)setWithBlock:(NSSet *(^)(void))block;


+(instancetype)new UNAVAILABLE_ATTRIBUTE;
-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end

#define HMRDelaySet(x) \
	((__typeof__(x))[HMRDelaySet setWithBlock:^{ return (x); }])
