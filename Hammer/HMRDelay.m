//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelay.h"
#import "HMRParserCombinator.h"

@implementation HMRDelay {
	HMRDelayBlock _block;
	id _forced;
	Class _class;
}

+(id)delay:(HMRDelayBlock)block class:(Class)class {
	return [[self alloc] initWithBlock:block class:class];
}

-(instancetype)initWithBlock:(HMRDelayBlock)block class:(Class)class {
	NSParameterAssert(block != nil);
	
	_block = [block copy];
	_class = class;
	return self;
}


-(id)force {
	HMRDelayBlock block = _block;
	_block = nil;
	if (block) {
		_forced = block();
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

-(Class)class {
	return _class;
}

-(BOOL)isKindOfClass:(Class)class {
	return [self.forced isKindOfClass:class];
}


-(id)forwardingTargetForSelector:(SEL)selector {
	return self.forced;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
	return [_class instanceMethodSignatureForSelector:selector];
}

-(void)forwardInvocation:(NSInvocation *)invocation {
	[invocation invokeWithTarget:self.forced];
}

-(BOOL)respondsToSelector:(SEL)selector {
	return [_class instancesRespondToSelector:selector];
}


-(BOOL)isEqual:(id)object {
	return [self.forced isEqual:object];
}


-(NSString *)debugDescription {
	return [NSString stringWithFormat:@"<HMRDelay %p> %@", self, self.description];
}

-(NSString *)description {
	return [@"λ." stringByAppendingString:[self.forced description]];
}

@end


@implementation HMRDelayCombinator

-(instancetype)initWithBlock:(HMRDelayBlock)block {
	return [super initWithBlock:block class:[HMRParserCombinator class]];
}


#pragma mark HMRCombinator

-(NSSet *)parseForest {
	return [self.forced parseForest];
}

l3_test(@selector(parseForest)) {
	NSSet *forest = [NSSet setWithObject:@"a"];
	id<HMRCombinator> capture = HMRCaptureForest(forest);
	id<HMRCombinator> delayed = HMRDelay(capture);
	l3_expect(HMRDelay(delayed.parseForest)).to.equal(forest);
	l3_expect(forest).to.equal(delayed.parseForest);
}


-(id<HMRCombinator>)compaction {
	return [self.forced compaction];
}


-(id<HMRCombinator>)derivative:(id)object {
	return [self.forced derivative:object];
}

@end
