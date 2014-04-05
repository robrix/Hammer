//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelay.h"
#import "HMRLeastFixedPoint.h"
#import "HMRNonterminal.h"

@implementation HMRNonterminal {
	NSMutableDictionary *_derivativesByElements;
	NSSet *_parseForest;
	NSString *_description;
	NSNumber *_nullable;
	NSNumber *_cyclic;
}

-(instancetype)init {
	if ((self = [super init])) {
		_derivativesByElements = [NSMutableDictionary new];
		
		__weak HMRNonterminal *weakSelf = self;
		
		_nullable = HMRDelaySpecific([NSNumber class], _nullable = HMRLeastFixedPoint(_nullable = @NO, ^(id _) {
			return _nullable = [weakSelf computeNullability]? @YES : @NO;
		}));
		
		_parseForest = HMRDelaySpecific([NSSet class], _parseForest = HMRLeastFixedPoint(_parseForest = [NSSet set], ^(NSSet *_) {
			return _parseForest = [weakSelf reduceParseForest];
		}));
		
		_compaction = HMRDelay(({
			id<HMRCombinator> compacted = [[weakSelf compact] self];
			NSCParameterAssert(compacted != nil);
			compacted == weakSelf? compacted : [compacted withName:[self.name stringByAppendingString:@"ʹ"]];
		}));
		
		_description = HMRDelaySpecific([NSString class], ({
			_description = weakSelf.name ?: super.description;
			NSString *description = [weakSelf describe];
			weakSelf.name? [[weakSelf.name stringByAppendingString:@" -> "] stringByAppendingString:description] : description;
		}));
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
	return _nullable.boolValue;
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
