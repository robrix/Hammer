//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRCombinator.h"
#import "HMRDelay.h"
#import "HMRMemoization.h"
#import "HMROnce.h"

@implementation HMRCombinator

#pragma mark Terminal construction

+(HMREmpty *)empty {
	return HMROnce([HMREmpty new]);
}


+(HMRNull *)null {
	return HMROnce([HMRNull new]);
}


+(HMRLiteral *)literal:(id<NSObject,NSCopying>)object {
	return [HMRLiteral literal:object];
}

+(HMRContainment *)containedIn:(id<HMRSet>)set {
	return [HMRContainment containedIn:set];
}


+(HMRNull *)captureTree:(id)object {
	return [HMRNull captureForest:[NSSet setWithObject:object]];
}

+(HMRNull *)capture:(NSSet *)forest {
	return [HMRNull captureForest:forest];
}



#pragma mark Nonterminal construction

-(HMRAlternation *)or:(HMRCombinator *)other {
	return [HMRAlternation alternateLeft:self right:other];
}

typedef HMRCombinator *(^HMRCombinatorPairBlock)(HMRCombinator *, HMRCombinator *);
HMRCombinator *(^HMRCombineVariadics)(HMRCombinator *, va_list, HMRCombinatorPairBlock) = ^HMRCombinator *(HMRCombinator *each, va_list args, HMRCombinatorPairBlock pair) {
	if (each) {
		HMRCombinator *rest = HMRCombineVariadics(va_arg(args, HMRCombinator *), args, pair);
		each = rest?
			pair(each, rest)
		:	each;
	}
	return each;
};

+(HMRCombinator *)alternate:(HMRCombinator *)leftmost, ... {
	va_list args;
	va_start(args, leftmost);
	
	HMRCombinator *alternation = HMRCombineVariadics(leftmost, args, ^(HMRCombinator *left, HMRCombinator *right) {
		return [left or:right];
	});
	
	va_end(args);
	
	return alternation;
}

l3_test(@selector(alternate:)) {
	HMRCombinator *sub = [HMRCombinator literal:@"x"];
	l3_expect([HMRCombinator alternate:sub, sub, sub, nil]).to.equal([sub or:[sub or:sub]]);
}


-(HMRIntersection *)and:(HMRCombinator *)other {
	return [HMRIntersection intersectLeft:self right:other];
}

+(HMRCombinator *)intersect:(HMRCombinator *)leftmost, ... {
	va_list args;
	va_start(args, leftmost);
	
	HMRCombinator *intersection = HMRCombineVariadics(leftmost, args, ^(HMRCombinator *left, HMRCombinator *right) {
		return [left and:right];
	});
	
	va_end(args);
	
	return intersection;
}

l3_test(@selector(intersect:)) {
	HMRCombinator *sub = [HMRCombinator literal:@"x"];
	l3_expect([HMRCombinator intersect:sub, sub, sub, nil]).to.equal([sub and:[sub and:sub]]);
}


-(HMRConcatenation *)concat:(HMRCombinator *)other {
	return [HMRConcatenation concatenateFirst:self second:other];
}

+(HMRCombinator *)concatenate:(HMRCombinator *)first, ... {
	va_list args;
	va_start(args, first);
	
	HMRCombinator *concatenation = HMRCombineVariadics(first, args, ^(HMRCombinator *first, HMRCombinator *second) {
		return [first concat:second];
	});
	
	va_end(args);
	
	return concatenation;
}

l3_test(@selector(concatenate:)) {
	HMRCombinator *sub = [HMRCombinator literal:@"x"];
	l3_expect([HMRConcatenation concatenate:sub, sub, sub, nil]).to.equal([sub concat:[sub concat:sub]]);
}


-(HMRReduction *)mapSet:(HMRReductionBlock)block {
	return [HMRReduction reduce:self usingBlock:block];
}

-(HMRReduction *)map:(REDMapBlock)block {
	return [HMRReduction reduce:self usingBlock:^(id<REDReducible> forest) {
		return REDMap(forest, block);
	}];
}


-(HMRRepetition *)repeat {
	return [HMRRepetition repeat:self];
}


#pragma mark HMRCombinator

-(HMRCombinator *)derivative:(id<NSObject,NSCopying>)object {
	return [self.class empty];
}


-(NSSet *)parseForest {
	NSMutableDictionary *cache = [NSMutableDictionary new];
	static NSSet *(^parseForest)(HMRCombinator *, NSMutableDictionary *) = ^NSSet *(HMRCombinator *combinator, NSMutableDictionary *cache) {
		return cache[combinator] ?: (cache[combinator] = [NSSet set], HMRMatch(combinator, @[
			[HMRAlternated(HMRBind(), HMRBind()) then:^(HMRCombinator *left, HMRCombinator *right) {
				return [parseForest(left, cache) setByAddingObjectsFromSet:parseForest(right, cache)];
			}],
			
			[HMRConcatenated(HMRBind(), HMRBind()) then:^(HMRCombinator *first, HMRCombinator *second) {
				NSSet *prefix = parseForest(first, cache);
				NSSet *suffix = parseForest(second, cache);
				return [[NSSet set] red_append:REDFlattenMap(prefix, ^(id x) {
					return REDMap(suffix, ^(id y) {
						return HMRCons(x, y);
					});
				})];
			}],
			
			[HMRReduced(HMRBind(), HMRBind()) then:^(HMRCombinator *combinator, HMRReductionBlock block) {
				return [combinator isKindOfClass:[HMRNull class]]?
					[[NSSet set] red_append:block(parseForest(combinator, cache))]
				:	HMRDelaySpecific([NSSet class], [[NSSet set] red_append:block(parseForest(combinator, cache))]);
			}],
			
			[HMRRepeated(HMRAny()) then:^{
				return [NSSet setWithObject:[HMRPair null]];
			}],
			
			[[HMRKindOf kindOfClass:[HMRNull class]] then:^{
				return combinator.parseForest;
			}],
			
			[HMRAny() then:^{ return [NSSet set]; }],
		]));
	};
	return parseForest(self, cache);
}

l3_test(@selector(parseForest)) {
	l3_expect([[HMRCombinator captureTree:@"a"] or:[HMRCombinator captureTree:@"b"]].parseForest).to.equal([NSSet setWithObjects:@"a", @"b", nil]);
	
	l3_expect([[HMRCombinator captureTree:@"a"] concat:[HMRCombinator captureTree:@"b"]].parseForest).to.equal([NSSet setWithObject:HMRCons(@"a", @"b")]);
	
	__block HMRCombinator *cyclic = [[[HMRCombinator literal:@"a"] concat:HMRDelay(cyclic)] map:REDIdentityMapBlock];
	l3_expect(cyclic.parseForest).to.equal([NSSet set]);
	cyclic = [[[HMRCombinator capture:[NSSet setWithObjects:@"a", @"b", nil]] or:HMRDelay(cyclic)] map:^(id each) {
		return [each stringByAppendingString:each];
	}];
	l3_expect(cyclic.parseForest).to.equal([NSSet setWithObjects:@"aa", @"bb", nil]);
	
	cyclic = [[[HMRCombinator captureTree:@"a"] concat:[HMRCombinator captureTree:@"b"]] or:HMRDelay(cyclic)];
	l3_expect(cyclic.parseForest).to.equal([NSSet setWithObject:HMRCons(@"a", @"b")]);
	cyclic = [[[HMRCombinator captureTree:@"a"] concat:[HMRCombinator captureTree:@"b"]] concat:HMRDelay(cyclic)];
	l3_expect(cyclic.parseForest).to.equal([NSSet set]);
	
	l3_expect([HMRAny() parseForest]).to.equal([NSSet set]);
}


-(HMRCombinator *)compaction {
	return self;
}


@synthesize name = _name;

-(instancetype)withName:(NSString *)name {
	if (!_name) _name = [name copy];
	return self;
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return ![[self derivative:object] isEqual:[self.class empty]];
}

-(id<HMRCase>)then:(id (^)())block {
	return [HMRCase caseWithPredicate:self block:block];
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return block(initial, self);
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}


#pragma mark NSObject

-(BOOL)isEqual:(id)object {
	return [object isKindOfClass:self.class];
}

@end
