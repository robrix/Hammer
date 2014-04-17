//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRBlockCombinator.h"
#import "HMRConcatenation.h"
#import "HMRNull.h"
#import "HMROperations.h"
#import "HMRPair.h"
#import "HMRReduction.h"

@implementation HMRConcatenation

-(instancetype)initWithFirst:(HMRCombinator *)first second:(HMRCombinator *)second {
	if ((self = [super init])) {
		_first = [first copyWithZone:NULL];
		_second = [second copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(HMRCombinator *)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	HMRCombinator *first = self.first;
	HMRCombinator *second = self.second;
	HMRCombinator *derivativeAfterFirst = [[first derivative:object] and:second];
	return HMRCombinatorIsNullable(first)?
		[derivativeAfterFirst or:[HMRCaptureForest(first.parseForest) and:[second derivative:object]]]
	:	derivativeAfterFirst;
}

l3_test(@selector(derivative:)) {
	id first = @"a";
	id second = @"b";
	id other = @"";
	HMRCombinator *concatenation = [HMREqual(first) and:HMREqual(second)];
	l3_expect([[concatenation derivative:first] derivative:second].parseForest).to.equal([NSSet setWithObject:HMRCons(first, second)]);
	l3_expect([[concatenation derivative:first] derivative:other].parseForest).to.equal([NSSet set]);
	
	id third = @"c";
	concatenation = HMRAnd(HMREqual(first), HMRAnd(HMREqual(second), HMREqual(third)));
	l3_expect([[[concatenation derivative:first] derivative:second] derivative:third].parseForest).to.equal([NSSet setWithObject:HMRCons(first, HMRCons(second, third))]);
	
	__block HMRCombinator *cyclic = HMRAnd(HMREqual(first), HMROr(HMRDelay(cyclic), HMREqual(second)));
	l3_expect([[cyclic derivative:first] derivative:second].parseForest).to.equal(([NSSet setWithObject:HMRCons(first, second)]));
	l3_expect([[[cyclic derivative:first] derivative:first] derivative:second].parseForest).to.equal(([NSSet setWithObject:HMRCons(first, HMRCons(first, second))]));
	l3_expect([[[[cyclic derivative:first] derivative:first] derivative:first] derivative:second].parseForest).to.equal(([NSSet setWithObject:HMRCons(first, HMRCons(first, HMRCons(first, second)))]));
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


-(HMRCombinator *)compact {
	HMRCombinator *first = self.first.compaction;
	HMRCombinator *second = self.second.compaction;
	__block HMRCombinator *concatenation;
	if ([first isEqual:HMRNone()] || [second isEqual:HMRNone()])
		concatenation = HMRNone();
	else if ([first isKindOfClass:[HMRNull class]]) {
		NSSet *parseForest = first.parseForest;
		concatenation = [(HMRReduction *)HMRMap(second, ^(id<NSObject,NSCopying> each) {
			return HMRCons(parseForest.anyObject, each);
		}) withFunctionDescription:[NSString stringWithFormat:@"(%@ .)", first]];
	}
	else if ([second isKindOfClass:[HMRNull class]]) {
		NSSet *parseForest = second.parseForest;
		concatenation = [(HMRReduction *)HMRMap(first, ^(id<NSObject,NSCopying> each) {
			return HMRCons(each, parseForest.anyObject);
		}) withFunctionDescription:[NSString stringWithFormat:@"(. %@)", second]];
	}
	else if ([first isKindOfClass:[HMRNull class]] && [second.parseForest isKindOfClass:[HMRNull class]])
		concatenation = HMRCaptureForest([HMRConcatenation concatenateParseForestWithPrefix:first.parseForest suffix:second.parseForest]);
	else if (first == self.first && second == self.second)
		concatenation = self;
	else
		concatenation = HMRAnd(first, second);
	return concatenation;
}

l3_test(@selector(compaction)) {
	HMRCombinator *anything = HMREqual(@0);
	HMRCombinator *empty = HMRNone();
	l3_expect(HMRAnd(empty, anything).compaction).to.equal(empty);
	l3_expect(HMRAnd(anything, empty).compaction).to.equal(empty);
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"(%@ × %@)", self.first.name ?: self.first.description, self.second.name ?: self.second.description];
}


-(NSUInteger)computeHash {
	return
		[super computeHash]
	^	self.first.hash
	^	self.second.hash;
}


-(id)reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return [self.second red_reduce:[self.first red_reduce:[super reduce:initial usingBlock:block] usingBlock:block] usingBlock:block];
}

l3_test(@selector(red_reduce:usingBlock:)) {
	NSNumber *(^count)(NSNumber *, HMRCombinator *) = ^(NSNumber *into, HMRCombinator *each) {
		return @(into.integerValue + 1);
	};
	NSNumber *size = [HMRAnd(HMREqual(@"x"), HMREqual(@"y")) red_reduce:@0 usingBlock:count];
	l3_expect(size).to.equal(@3);
	__block HMRCombinator *cyclic;
	cyclic = HMRAnd(HMREqual(@"x"), HMRDelay(cyclic));
	
	size = [cyclic red_reduce:@0 usingBlock:count];
	l3_expect(size).to.equal(@2);
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return
		[self.first matchObject:object]
	&&	[self.second matchObject:object];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRConcatenation *)object {
	return
		[object isKindOfClass:self.class]
	&&	[self.first isEqual:object.first]
	&&	[self.second isEqual:object.second];
}

@end


HMRConcatenation *HMRAnd(HMRCombinator *first, HMRCombinator *second) {
	NSCParameterAssert(first != nil);
	NSCParameterAssert(second != nil);
	
	return [[HMRConcatenation alloc] initWithFirst:first second:second];
}

id<HMRPredicate> HMRConcatenated(id<HMRPredicate> first, id<HMRPredicate> second) {
	first = first ?: HMRAny();
	second = second ?: HMRAny();
	return [[HMRBlockCombinator alloc] initWithBlock:^bool (HMRConcatenation *subject) {
		return
			[subject isKindOfClass:[HMRConcatenation class]]
		&&	[first matchObject:subject.first]
		&&	[second matchObject:subject.second];
	}];
}
