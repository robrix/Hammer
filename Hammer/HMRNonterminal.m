//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRDelay.h"
#import "HMRMemoization.h"
#import "HMRNonterminal.h"

@implementation HMRNonterminal {
	NSMutableDictionary *_derivativesByElements;
	NSSet *_parseForest;
	NSNumber *_nullable;
	__weak HMRCombinator *_compaction;
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

-(HMRCombinator *)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return nil;
}

-(HMRCombinator *)derivative:(id<NSObject, NSCopying>)object {
	return HMRMemoize(_derivativesByElements[object], [HMRCombinator empty], [self deriveWithRespectToObject:object].compaction);
}


-(NSSet *)reduceParseForest {
	return [NSSet set];
}

-(NSSet *)parseForest {
	return HMRMemoize(_parseForest, [NSSet set], [self reduceParseForest]);
}


-(HMRCombinator *)compact {
	return self;
}

-(HMRCombinator *)compaction {
	return
		_compaction
	?:	(_compaction = HMRDelay([(id)[self compact] withName:self.name]));
}


-(NSString *)describe {
	return super.description;
}

-(NSString *)description {
	return HMRMemoize(_description, self.name ?: super.description, self.name?
			[[self.name stringByAppendingString:@" -> "] stringByAppendingString:[self describe]]
		:	[self describe]);
}


-(NSUInteger)computeHash {
	return self.class.description.hash;
}

-(NSUInteger)hash {
	return HMRMemoize(_hash, @0, @([self computeHash])).unsignedIntegerValue;
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

@end
