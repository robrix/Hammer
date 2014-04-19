//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelaySet.h"

@implementation HMRDelaySet {
	NSSet *(^_block)(void);
	NSSet *_forced;
	bool _forcing;
}


+(instancetype)setWithBlock:(NSSet *(^)(void))block {
	return [(HMRDelaySet *)[self alloc] initWithBlock:block];
}

-(instancetype)initWithBlock:(NSSet *(^)(void))block {
	if ((self = [super init])) {
		_block = [block copy];
	}
	return self;
}


-(NSSet *)forced {
	NSSet *(^block)(void) = _block;
	_block = nil;
	if (block) {
		_forcing = YES;
		_forced = block();
		_forcing = NO;
	}
	return _forced;
}


#pragma mark NSSet

-(NSUInteger)count {
	return self.forced.count;
}

-(id)member:(id)object {
	return [self.forced member:object];
}

-(NSEnumerator *)objectEnumerator {
	return [self.forced objectEnumerator];
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}


#pragma mark NSObject

-(NSUInteger)hash {
	return _forced.hash;
}

@end
