//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRCombinator.h"
#import "HMRDelaySet.h"
#import "HMRKindOf.h"
#import "HMRMemoization.h"
#import "HMROnce.h"

@implementation HMRCombinator {
	NSNumber *_cyclic;
}

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


#pragma mark Predicate construction

+(HMRCombinator *)quote {
	return [HMRKindOf kindOfClass:self];
}

l3_test(@selector(quote)) {
	l3_expect([[HMRNull quote] matchObject:[HMRCombinator captureTree:@"a"]]).to.equal(@YES);
	l3_expect([[HMRNull quote] matchObject:[HMRCombinator literal:@"a"]]).to.equal(@NO);
}


-(HMRCombinator *)quote {
	return [self.class quote];
}


#pragma mark HMRCombinator

-(HMRCombinator *)derivative:(id<NSObject,NSCopying>)object {
	return [self.class empty];
}


-(NSSet *)parseForest {
	NSMutableDictionary *cache = [NSMutableDictionary new];
	static NSSet *(^parseForest)(HMRCombinator *, NSMutableDictionary *) = ^NSSet *(HMRCombinator *combinator, NSMutableDictionary *cache) {
		return cache[combinator] ?: (cache[combinator] = [NSSet set], cache[combinator] = HMRMatch(combinator, @[
			[[[HMRBind() or:HMRBind()] quote] then:^(HMRCombinator *left, HMRCombinator *right) {
				return [parseForest(left, cache) setByAddingObjectsFromSet:parseForest(right, cache)];
			}],
			
			[[[HMRBind() and:HMRBind()] quote] then:^(HMRCombinator *left, HMRCombinator *right) {
				NSSet *leftSet = parseForest(left, cache), *rightSet = parseForest(right, cache);
				NSMutableSet *intersection = [leftSet mutableCopy];
				[intersection intersectSet:rightSet];
				return intersection;
			}],
			
			[[[HMRBind() concat:HMRBind()] quote] then:^(HMRCombinator *first, HMRCombinator *second) {
				NSSet *prefix = parseForest(first, cache);
				NSSet *suffix = parseForest(second, cache);
				return [[NSSet set] red_append:REDFlattenMap(prefix, ^(id x) {
					return REDMap(suffix, ^(id y) {
						return HMRCons(x, y);
					});
				})];
			}],
			
			[[[HMRBind() map:REDIdentityMapBlock] quote] then:^(HMRCombinator *combinator, HMRReductionBlock block) {
				return [combinator isKindOfClass:[HMRNull class]]?
					[[NSSet set] red_append:block(parseForest(combinator, cache))]
				:	HMRDelaySet([[NSSet set] red_append:block(parseForest(combinator, cache))]);
			}],
			
			[[[HMRAny() repeat] quote] then:^{
				return [NSSet setWithObject:[HMRPair null]];
			}],
			
			[[HMRNull quote] then:^{
				return combinator.parseForest;
			}],
			
			[HMRAny() then:^{ return [NSSet set]; }],
		]));
	};
	return parseForest(self, cache);
}

l3_test(@selector(parseForest)) {
	HMRCombinator *a = [HMRCombinator captureTree:@"a"], *b = [HMRCombinator captureTree:@"b"];
	l3_expect([a or:b].parseForest).to.equal([NSSet setWithObjects:@"a", @"b", nil]);
	
	l3_expect([a and:b].parseForest).to.equal([NSSet set]);
	l3_expect([a and:a].parseForest).to.equal([NSSet setWithObject:@"a"]);
	
	l3_expect([a concat:b].parseForest).to.equal([NSSet setWithObject:HMRCons(@"a", @"b")]);
	
	__block HMRCombinator *cyclic = [[[HMRCombinator literal:@"a"] concat:HMRDelay(cyclic)] map:REDIdentityMapBlock];
	l3_expect(cyclic.parseForest).to.equal([NSSet set]);
	cyclic = [[[HMRCombinator capture:[NSSet setWithObjects:@"a", @"b", nil]] or:HMRDelay(cyclic)] map:^(id each) {
		return [each stringByAppendingString:each];
	}];
	l3_expect(cyclic.parseForest).to.equal([NSSet setWithObjects:@"aa", @"bb", nil]);
	
	cyclic = [[a concat:b] or:HMRDelay(cyclic)];
	l3_expect(cyclic.parseForest).to.equal([NSSet setWithObject:HMRCons(@"a", @"b")]);
	cyclic = [[a concat:b] concat:HMRDelay(cyclic)];
	l3_expect(cyclic.parseForest).to.equal([NSSet set]);
	
	l3_expect([HMRAny() parseForest]).to.equal([NSSet set]);
}


-(HMRCombinator *)compaction {
	return self;
}


-(bool)isCyclic {
	NSMutableDictionary *cache = [NSMutableDictionary new];
	
	static bool (^isCyclic)(HMRCombinator *, NSMutableDictionary *) = ^bool (HMRCombinator *combinator, NSMutableDictionary *cache) {
		return [cache[combinator] ?: (cache[combinator] = @YES, cache[combinator] = HMRMatch(combinator, @[
			[[[HMRBind() or:HMRBind()] quote] then:^(HMRCombinator *left, HMRCombinator *right) {
				return @(isCyclic(left, cache) || isCyclic(right, cache));
			}],
			
			[[[HMRBind() and:HMRBind()] quote] then:^(HMRCombinator *left, HMRCombinator *right) {
				return @(isCyclic(left, cache) || isCyclic(right, cache));
			}],
			
			[[[HMRBind() concat:HMRBind()] quote] then:^(HMRCombinator *first, HMRCombinator *second) {
				return @(isCyclic(first, cache) || isCyclic(second, cache));
			}],
			
			[HMRReduced(HMRBind(), HMRAny()) then:^(HMRCombinator *combinator) {
				return @(isCyclic(combinator, cache));
			}],
			
			[[[HMRBind() repeat] quote] then:^(HMRCombinator *combinator) {
				return @(isCyclic(combinator, cache));
			}],
			
			[HMRAny() then:^{ return @NO; }],
		])) boolValue];
	};
	
	return (_cyclic ?: (_cyclic = @(isCyclic(self, cache)))).boolValue;
}

l3_test(@selector(isCyclic)) {
	HMRCombinator *x = [HMRCombinator literal:@"x"];
	l3_expect(x.isCyclic).to.equal(@NO);
	l3_expect([x concat:x].isCyclic).to.equal(@NO);
	
	__block HMRCombinator *cyclic = [x concat:HMRDelay(cyclic)];
	l3_expect(cyclic.isCyclic).to.equal(@YES);
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
