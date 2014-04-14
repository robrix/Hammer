//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRConcatenation.h"
#import "HMRNull.h"
#import "HMROperations.h"
#import "HMRPair.h"
#import "HMRReduction.h"

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
	id<HMRCombinator> first = self.first;
	id<HMRCombinator> second = self.second;
	id<HMRCombinator> derivativeAfterFirst = HMRAnd([first derivative:object], second);
	return HMRCombinatorIsNullable(first)?
		HMROr(derivativeAfterFirst, HMRAnd(HMRCaptureForest(first.parseForest), [second derivative:object]))
	:	derivativeAfterFirst;
}

l3_test(@selector(derivative:)) {
	id first = @"a";
	id second = @"b";
	id other = @"";
	id<HMRCombinator> concatenation = HMRAnd(HMRLiteral(first), HMRLiteral(second));
	l3_expect([[concatenation derivative:first] derivative:second].parseForest).to.equal([NSSet setWithObject:HMRCons(first, second)]);
	l3_expect([[concatenation derivative:first] derivative:other].parseForest).to.equal([NSSet set]);
	
	id third = @"c";
	concatenation = HMRAnd(HMRLiteral(first), HMRAnd(HMRLiteral(second), HMRLiteral(third)));
	l3_expect([[[concatenation derivative:first] derivative:second] derivative:third].parseForest).to.equal([NSSet setWithObject:HMRCons(first, HMRCons(second, third))]);
	
	__block id<HMRCombinator> cyclic = HMRAnd(HMRLiteral(first), HMROr(HMRDelay(cyclic), HMRLiteral(second)));
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


-(id<HMRCombinator>)compact {
	id<HMRCombinator> first = self.first.compaction;
	id<HMRCombinator> second = self.second.compaction;
	__block id<HMRCombinator> concatenation;
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
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = HMRNone();
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
	NSNumber *(^count)(NSNumber *, id<HMRCombinator>) = ^(NSNumber *into, id<HMRCombinator> each) {
		return @(into.integerValue + 1);
	};
	NSNumber *size = [HMRAnd(HMRLiteral(@"x"), HMRLiteral(@"y")) red_reduce:@0 usingBlock:count];
	l3_expect(size).to.equal(@3);
	__block id<HMRCombinator> cyclic;
	cyclic = HMRAnd(HMRLiteral(@"x"), HMRDelay(cyclic));
	
	size = [cyclic red_reduce:@0 usingBlock:count];
	l3_expect(size).to.equal(@2);
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRConcatenation *)object {
	return
		[object isKindOfClass:self.class]
	&&	[self.first isEqual:object.first]
	&&	[self.second isEqual:object.second];
}

@end


id<HMRCombinator> HMRAnd(id<HMRCombinator> first, id<HMRCombinator> second) {
	NSCParameterAssert(first != nil);
	NSCParameterAssert(second != nil);
	
	return [[HMRConcatenation alloc] initWithFirst:first second:second];
}


REDPredicateBlock HMRConcatenationPredicate(REDPredicateBlock first, REDPredicateBlock second) {
	first = first ?: REDTruePredicateBlock;
	second = second ?: REDTruePredicateBlock;
	
	return [^bool (HMRConcatenation *combinator) {
		return
			[combinator isKindOfClass:[HMRConcatenation class]]
		&&	first(combinator.first)
		&&	second(combinator.second);
	} copy];
}
