//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelay.h"
#import "HMRMemoization.h"
#import "HMRNonterminal.h"

@implementation HMRNonterminal {
	NSMutableDictionary *_derivativesByElements;
	NSSet *_parseForest;
	NSNumber *_nullable;
	NSNumber *_cyclic;
	__weak id<HMRCombinator> _compaction;
	NSString *_description;
	bool _reducing;
}

-(instancetype)init {
	if ((self = [super init])) {
		_derivativesByElements = [NSMutableDictionary new];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return nil;
}

-(id<HMRCombinator>)derivative:(id<NSObject, NSCopying>)object {
	return HMRMemoize(_derivativesByElements[object], HMRNone(), [self deriveWithRespectToObject:object].compaction);
}


-(NSSet *)reduceParseForest {
	return [NSSet set];
}

-(NSSet *)parseForest {
	return HMRMemoize(_parseForest, [NSSet set], [self reduceParseForest]);
}


-(bool)computeNullability {
	return NO;
}

-(bool)isNullable {
	return HMRMemoize(_nullable, @NO, @([self computeNullability])).boolValue;
}


-(bool)computeCyclic {
	return NO;
}

-(bool)isCyclic {
	return HMRMemoize(_cyclic, @YES, @([self computeCyclic])).boolValue;
}


-(id<HMRCombinator>)compact {
	return self;
}

-(id<HMRCombinator>)compaction {
	return
		_compaction
	?:	(_compaction = HMRDelay([[self compact] withName:self.name]));
}


-(NSString *)describe {
	return super.description;
}

-(NSString *)description {
	return HMRMemoize(_description, self.name ?: super.description, self.name?
			[[self.name stringByAppendingString:@" -> "] stringByAppendingString:[self describe]]
		:	[self describe]);
}


@synthesize name = _name;

-(instancetype)withName:(NSString *)name {
	if (!_name) _name = name;
	return self;
}


#pragma mark REDReducible

-(id)reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return block(initial, self);
}

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	id reduced = initial;
	if (!_reducing) {
		_reducing = YES;
		reduced = [self reduce:reduced usingBlock:block];
		_reducing = NO;
	}
	return reduced;
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}

@end
