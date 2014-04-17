//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelay.h"
#import <objc/runtime.h>

@implementation HMRDelay {
	Class _class;
	HMRDelayBlock _block;
	id _forced;
}

-(instancetype)initWithClass:(Class)class block:(HMRDelayBlock)block {
	NSParameterAssert(block != nil);
	
	_class = class;
	_block = [block copy];
	return self;
}


-(id)force {
	HMRDelayBlock block = _block;
	_block = nil;
	if (block) {
		_forcing = YES;
		_forced = [block() self];
		_forcing = NO;
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

-(instancetype)copy {
	return self;
}


#pragma mark NSObject

-(Class)class {
	return _class;
}

-(BOOL)isKindOfClass:(Class)class {
	return [self.forced isKindOfClass:class];
}


-(id)forwardingTargetForSelector:(SEL)selector {
	return [self.forced self];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
	return [_class instanceMethodSignatureForSelector:selector];
}

-(void)forwardInvocation:(NSInvocation *)invocation {
	[invocation invokeWithTarget:self.forced];
}

-(BOOL)respondsToSelector:(SEL)selector {
	return
		(class_getInstanceMethod(object_getClass(self), selector) != NULL)
	||	[_class instancesRespondToSelector:selector];
}


-(BOOL)isEqual:(id)object {
	return
		object == self
	||	object == self.forced
	||	[self.forced isEqual:object];
}


-(NSString *)debugDescription {
	return [NSString stringWithFormat:@"<HMRDelay: %p> %@", self, self.description];
}

-(NSString *)description {
	return [@"λ." stringByAppendingString:[self.forced description]];
}


-(NSUInteger)hash {
	return ((id<NSObject>)self.forced).hash;
}

@end
