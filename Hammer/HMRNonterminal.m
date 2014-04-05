//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelay.h"
#import "HMRLeastFixedPoint.h"
#import "HMRNonterminal.h"

@implementation HMRNonterminal {
	NSMutableDictionary *_derivativesByElements;
	NSSet *_parseForest;
	NSString *_description;
	NSNumber *_nullability;
	NSNumber *_cyclic;
}

-(instancetype)init {
	if ((self = [super init])) {
		_derivativesByElements = [NSMutableDictionary new];
		
		__weak HMRNonterminal *weakSelf = self;
		
		_nullability = HMRDelaySpecific([NSNumber class], _nullability = HMRLeastFixedPoint(_nullability = @NO, ^(id _) {
			return _nullability = @([weakSelf computeNullability]);
		}));
		
		_parseForest = HMRDelaySpecific([NSSet class], _parseForest = HMRLeastFixedPoint(_parseForest = [NSSet set], ^(NSSet *_) {
			return _parseForest = [weakSelf reduceParseForest];
		}));
		
		_compaction = HMRDelay(({ id<HMRCombinator> compacted = [weakSelf compact]; compacted == self? compacted : [compacted withName:[self.name stringByAppendingString:@"ʹ"]]; }));
		
		_description = HMRDelaySpecific([NSString class], [([[weakSelf name] stringByAppendingString:@": "] ?: @"") stringByAppendingString:[weakSelf describe]]);
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

@synthesize parseForest = _parseForest;


-(bool)computeNullability {
	return NO;
}

-(bool)isNullable {
	return _nullability.boolValue;
}


-(bool)computeCyclic {
	return NO;
}

-(bool)isCyclic {
	if (_cyclic == nil) {
		if (self.computingCyclic) {
			_cyclic = @YES;
		} else {
			_computingCyclic = YES;
			_cyclic = @([self computeCyclic]);
			_computingCyclic = NO;
		}
	}
	return _cyclic.boolValue;
}


-(id<HMRCombinator>)compact {
	return self;
}

@synthesize compaction = _compaction;


-(NSString *)describe {
	return super.description;
}

@synthesize description = _description;


@synthesize name = _name;

-(instancetype)withName:(NSString *)name {
	_name = name;
	return self;
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}

@end
