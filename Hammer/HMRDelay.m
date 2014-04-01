//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelay.h"

@implementation HMRDelay {
	HMRDelayBlock _block;
	id _forced;
}

+(id)delay:(HMRDelayBlock)block {
	return [[self alloc] initWithBlock:block];
}

-(instancetype)initWithBlock:(HMRDelayBlock)block {
	NSParameterAssert(block != nil);
	
	_block = [block copy];
	return self;
}


-(id)force {
	id forced;
	if (_block) {
		forced = _block();
		_block = nil;
	}
	return forced;
}

-(id)forced {
	return _forced ?: (_forced = [self force]);
}


#pragma mark NSObject

-(id)forwardingTargetForSelector:(SEL)selector {
	return self.forced;
}

-(BOOL)isKindOfClass:(Class)class {
	return [self.forced isKindOfClass:class];
}

@end
