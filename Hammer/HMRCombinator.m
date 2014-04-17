//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMROnce.h"
#import "HMRCombinator.h"

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


-(HMRConcatenation *)and:(HMRCombinator *)other {
	return [HMRConcatenation concatenateFirst:self second:other];
}

+(HMRCombinator *)concatenate:(HMRCombinator *)first, ... {
	va_list args;
	va_start(args, first);
	
	HMRCombinator *concatenation = HMRCombineVariadics(first, args, ^(HMRCombinator *first, HMRCombinator *second) {
		return [first and:second];
	});
	
	va_end(args);
	
	return concatenation;
}

l3_test(@selector(concatenate:)) {
	HMRCombinator *sub = [HMRCombinator literal:@"x"];
	l3_expect([HMRConcatenation concatenate:sub, sub, sub, nil]).to.equal([sub and:[sub and:sub]]);
}


-(HMRReduction *)reduce:(HMRReductionBlock)block {
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
	return [NSSet set];
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
