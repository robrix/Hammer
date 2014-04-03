//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRCombinator.h>
#import <Hammer/HMRDelay.h>

@interface HMRDelayCombinator : HMRDelay <HMRCombinator>

-(instancetype)initWithBlock:(HMRDelayBlock)block;
-(instancetype)initWithBlock:(HMRDelayBlock)block class:(Class)class UNAVAILABLE_ATTRIBUTE;

@end
