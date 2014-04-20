//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRDelayCombinator.h"
#import "HMRNonterminal.h"
#import "HMRReduction.h"
#import "HMRKeyValueCoding.h"

@implementation HMRDelayCombinator {
	HMRCombinator *(^_block)(void);
	HMRCombinator *_forced;
}

+(Class)delayedClass {
	return [HMRNonterminal class];
}

-(instancetype)initWithBlock:(HMRCombinator *(^)(void))block {
	if ((self = [super init])) {
		_block = [block copy];
	}
	return self;
}


-(HMRCombinator *)forced {
	HMRCombinator *(^block)(void) = _block;
	_block = nil;
	if (block) {
		_forced = block();
	}
	return _forced;
}


#pragma mark HMRCombinator

-(HMRCombinator *)derivative:(id)object {
	return [self.forced derivative:object];
}


-(NSSet *)parseForest {
	return self.forced.parseForest;
}


-(HMRCombinator *)compaction {
	return self.forced.compaction;
}


-(NSString *)description {
	return [@"λ." stringByAppendingString:[self.forced description]];
}


-(HMRCombinator *)withFunctionDescription:(NSString *)functionDescription {
	return [(HMRReduction *)self.forced withFunctionDescription:functionDescription];
}

-(NSString *)functionDescription {
	return ((HMRReduction *)self.forced).functionDescription;
}


-(NSString *)name {
	return self.forced.name;
}

-(HMRCombinator *)withName:(NSString *)name {
	return (id)[self.forced withName:name];
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return [self.forced matchObject:object];
}

-(id<HMRCase>)then:(id (^)())block {
	return [HMRCase caseWithPredicate:self.forced block:block];
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return [self.forced red_reduce:initial usingBlock:block];
}


#pragma mark HMRKeyValueCoding

-(id)valueForKeyPath:(NSString *)keyPath {
	return [self.forced valueForKeyPath:keyPath];
}


#pragma mark NSObject

-(BOOL)isKindOfClass:(Class)class {
	return
		[super isKindOfClass:class]
	||	[self.forced isKindOfClass:class];
}

-(id)forwardingTargetForSelector:(SEL)selector {
	return self.forced;
}


-(instancetype)self {
	return (id)self.forced;
}

-(BOOL)isEqual:(id)object {
	return
		object == self
	||	object == self.forced
	||	[self.forced isEqual:object];
}

@end


HMRCombinator *HMRLazyCombinator(HMRCombinator *(^block)(void)) {
	return (id)[[HMRDelayCombinator alloc] initWithBlock:block];
}
