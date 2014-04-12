//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelayCombinator.h"

@interface HMRNullDelay : HMRDelayCombinator
@end

#define HMRDelayNull(...) \
	((__typeof__(__VA_ARGS__))[[HMRNullDelay alloc] initWithBlock:^{ return (__VA_ARGS__); }])
