//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRConcatenation.h"
#import "HMRNull.h"
#import "HMRPair.h"

@implementation HMRConcatenation

-(instancetype)initWithFirst:(id<HMRCombinator>)first second:(id<HMRCombinator>)second {
	if ((self = [super init])) {
		_first = [first copyWithZone:NULL];
		_second = [second copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	id<HMRCombinator> derivativeAfterFirst = HMRConcatenate([self.first derivative:object], self.second);
	return self.first.nullable?
		HMRAlternate(derivativeAfterFirst, HMRConcatenate(HMRCaptureForest(self.first.parseForest), [self.second derivative:object]))
	:	derivativeAfterFirst;
}

l3_test(@selector(derivative:)) {
	id first = @"a";
	id second = @"b";
	id other = @"";
	id<HMRCombinator> concatenation = HMRConcatenate(HMRLiteral(first), HMRLiteral(second));
	l3_expect([[concatenation derivative:first] derivative:second].parseForest).to.equal([NSSet setWithObject:HMRCons(first, second)]);
	l3_expect([[concatenation derivative:first] derivative:other].parseForest).to.equal([NSSet set]);
	
	id third = @"c";
	concatenation = HMRConcatenate(HMRLiteral(first), HMRConcatenate(HMRLiteral(second), HMRLiteral(third)));
	l3_expect([[[concatenation derivative:first] derivative:second] derivative:third].parseForest).to.equal([NSSet setWithObject:HMRCons(first, HMRCons(second, third))]);
	
	__block id<HMRCombinator> cyclic = HMRConcatenate(HMRLiteral(first), HMRAlternate(HMRDelay(cyclic), HMRLiteral(second)));
	l3_expect([[cyclic derivative:first] derivative:second].parseForest).to.equal(([NSSet setWithObject:HMRCons(first, second)]));
	l3_expect([[[cyclic derivative:first] derivative:first] derivative:second].parseForest).to.equal(([NSSet setWithObject:HMRCons(first, HMRCons(first, second))]));
	l3_expect([[[[cyclic derivative:first] derivative:first] derivative:first] derivative:second].parseForest).to.equal(([NSSet setWithObject:HMRCons(first, HMRCons(first, HMRCons(first, second)))]));
}


-(bool)computeNullability {
	return self.first.nullable && self.second.nullable;
}

l3_test(@selector(isNullable)) {
	id<HMRCombinator> nonNullable = HMRLiteral(@"x");
	id<HMRCombinator> nullable = HMRRepeat(nonNullable);
	l3_expect(HMRConcatenate(nonNullable, nonNullable).nullable).to.equal(@NO);
	l3_expect(HMRConcatenate(nonNullable, nullable).nullable).to.equal(@NO);
	l3_expect(HMRConcatenate(nullable, nonNullable).nullable).to.equal(@NO);
	l3_expect(HMRConcatenate(nullable, nullable).nullable).to.equal(@YES);
	
	__block id<HMRCombinator> cyclic;
	l3_expect((cyclic = HMRConcatenate(HMRDelay(cyclic), nullable)).nullable).to.equal(@NO);
	l3_expect((cyclic = HMRConcatenate(nullable, HMRDelay(cyclic))).nullable).to.equal(@NO);
	l3_expect((cyclic = HMRConcatenate(HMRAlternate(nullable, HMRDelay(cyclic)), nullable)).nullable).to.equal(@YES);
	l3_expect((cyclic = HMRConcatenate(nullable, HMRAlternate(nullable, HMRDelay(cyclic)))).nullable).to.equal(@YES);
	l3_expect((cyclic = HMRConcatenate(HMRAlternate(nonNullable, HMRDelay(cyclic)), nullable)).nullable).to.equal(@NO);
	l3_expect((cyclic = HMRConcatenate(nullable, HMRAlternate(nonNullable, HMRDelay(cyclic)))).nullable).to.equal(@NO);
}


-(bool)computeCyclic {
	return self.first.cyclic || self.second.cyclic;
}

l3_test(@selector(isCyclic)) {
	id<HMRCombinator> acyclic = HMRConcatenate(HMRNone(), HMRNone());
	l3_expect(acyclic.cyclic).to.equal(@NO);
	
	__block id<HMRCombinator> leftRecursive;
	leftRecursive = HMRConcatenate(HMRDelay(leftRecursive), HMRNone());
	l3_expect(leftRecursive.cyclic).to.equal(@YES);
	
	__block id<HMRCombinator> rightRecursive;
	rightRecursive = HMRConcatenate(HMRNone(), HMRDelay(rightRecursive));
	l3_expect(rightRecursive.cyclic).to.equal(@YES);
	
	__block id<HMRCombinator> mutuallyRecursive;
	mutuallyRecursive = HMRConcatenate(HMRDelay(mutuallyRecursive), HMRDelay(mutuallyRecursive));
	l3_expect(mutuallyRecursive.cyclic).to.equal(@YES);
}


+(NSSet *)concatenateParseForestWithPrefix:(NSSet *)prefix suffix:(NSSet *)suffix {
	return [[NSSet set] red_append:REDFlattenMap(prefix, ^(id x) {
		return REDMap(suffix, ^(id y) {
			return HMRCons(x, y);
		});
	})];
}

-(NSSet *)reduceParseForest {
	return [self.class concatenateParseForestWithPrefix:self.first.parseForest suffix:self.second.parseForest];
}


-(id<HMRCombinator>)compact {
	id<HMRCombinator> first = self.first.compaction;
	id<HMRCombinator> second = self.second.compaction;
	__block id<HMRCombinator> concatenation;
	if ([first isEqual:HMRNone()] || [second isEqual:HMRNone()])
		concatenation = HMRNone();
	else if ([first isKindOfClass:[HMRNull class]]) {
		NSSet *parseForest = first.parseForest;
		concatenation = HMRReduce(second, ^(id<NSObject,NSCopying> each) {
			return HMRCons(parseForest.anyObject, each);
		});
	}
	else if ([second isKindOfClass:[HMRNull class]]) {
		NSSet *parseForest = second.parseForest;
		concatenation = HMRReduce(first, ^(id<NSObject,NSCopying> each) {
			return HMRCons(each, parseForest.anyObject);
		});
	}
	else if ([first isKindOfClass:[HMRNull class]] && [second.parseForest isKindOfClass:[HMRNull class]])
		concatenation = HMRCaptureForest([HMRConcatenation concatenateParseForestWithPrefix:first.parseForest suffix:second.parseForest]);
	else if (first == self.first && second == self.second)
		concatenation = self;
	else
		concatenation = HMRConcatenate(first, second);
	return concatenation;
}

l3_test(@selector(compaction)) {
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = HMRNone();
	l3_expect(HMRConcatenate(empty, anything).compaction).to.equal(empty);
	l3_expect(HMRConcatenate(anything, empty).compaction).to.equal(empty);
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"(%@ ∘ %@)", self.first.name ?: self.first.description, self.second.name ?: self.second.description];
}

-(NSOrderedSet *)prettyPrint {
	NSMutableOrderedSet *prettyPrint = [[super prettyPrint] mutableCopy];
	[prettyPrint unionOrderedSet:self.first.prettyPrinted];
	[prettyPrint unionOrderedSet:self.second.prettyPrinted];
	return prettyPrint;
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRConcatenation *)object {
	return
		[object isKindOfClass:self.class]
	&&	[object.first isEqual:self.first]
	&&	[object.second isEqual:self.second];
}

@end


id<HMRCombinator> HMRConcatenate(id<HMRCombinator> first, id<HMRCombinator> second) {
	NSCParameterAssert(first != nil);
	NSCParameterAssert(second != nil);
	
	return [[HMRConcatenation alloc] initWithFirst:first second:second];
}
