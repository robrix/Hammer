//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelay.h"
#import "HMRLeastFixedPoint.h"
#import "HMRNonterminal.h"

#define HMRMemoize(var, initial, recursive) \
	((var) ?: ((var = (initial)), (var = (recursive))))

#define HMRFix(var, initial, recursive) \
	HMRMemoize((var), (initial), HMRLeastFixedPoint((initial), ^(id _) { return (var = (recursive)); }))

@implementation HMRNonterminal {
	NSMutableDictionary *_derivativesByElements;
	NSSet *_parseForest;
	NSNumber *_nullability;
	NSNumber *_cyclic;
	__weak id<HMRCombinator> _compaction;
	NSString *_description;
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
	__weak HMRNonterminal *weakSelf = self;
	return _derivativesByElements[object] ?: (_derivativesByElements[object] = HMRDelay(_derivativesByElements[object] = [weakSelf deriveWithRespectToObject:object].compaction));
}


-(NSSet *)reduceParseForest {
	return [NSSet set];
}

-(NSSet *)parseForest {
	return HMRFix(_parseForest, [NSSet set], [self reduceParseForest]);
}


-(bool)computeNullability {
	return NO;
}

-(bool)isNullable {
	return HMRFix(_nullability, @NO, @([self computeNullability])).boolValue;
}


-(bool)computeCyclic {
	return NO;
}

-(bool)isCyclic {
	return HMRFix(_cyclic, @YES, @([self computeCyclic])).boolValue;
}


-(id<HMRCombinator>)compact {
	return self;
}

-(id<HMRCombinator>)compaction {
	return HMRMemoize(_compaction, self, [self compact]);
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


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}

@end
