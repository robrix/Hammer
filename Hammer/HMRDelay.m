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
	if (!_forced) {
		_forced = self;
		_forced = _block();
		_block = nil;
	}
	return _forced;
}

-(id)forced {
	return _forced ?: [self force];
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}


#pragma mark NSObject

-(id)forwardingTargetForSelector:(SEL)selector {
	return self.forced;
}

-(BOOL)isKindOfClass:(Class)class {
	return [self.forced isKindOfClass:class];
}

@end
