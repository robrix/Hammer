//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRDelay.h"
#import "HMRMemoization.h"
#import "HMRNonterminal.h"

@implementation HMRNonterminal {
	NSMutableDictionary *_derivativesByElements;
	NSSet *_parseForest;
	NSNumber *_nullable;
	__weak id<HMRCombinator> _compaction;
	NSString *_description;
	NSNumber *_hash;
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
	return HMRMemoize(_derivativesByElements[object], HMRNone(), [[self deriveWithRespectToObject:object].compaction withName:[self.name stringByAppendingString:@"′"]]);
}


-(NSSet *)reduceParseForest {
	return [NSSet set];
}

-(NSSet *)parseForest {
	return HMRMemoize(_parseForest, [NSSet set], [self reduceParseForest]);
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
	if (!_name) _name = [name copy];
	return self;
}


-(NSUInteger)computeHash {
	return self.class.description.hash;
}

-(NSUInteger)hash {
	return HMRMemoize(_hash, @0, @([self computeHash])).unsignedIntegerValue;
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return ![[self derivative:object] isEqual:HMRNone()];
}

-(id<HMRCase>)then:(id (^)())block {
	return [HMRCase caseWithPredicate:self block:block];
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
