//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRCombinator.h"

@implementation HMRCombinator

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
	HMRCombinator *sub = HMREqual(@"x");
	l3_expect([HMRCombinator alternate:sub, sub, sub, nil]).to.equal([sub or:[sub or:sub]]);
}


-(HMRConcatenation *)and:(HMRCombinator *)other {
	return [HMRConcatenation concatenateFirst:self second:other];
}



-(HMRReduction *)map:(HMRReductionBlock)f {
	return [HMRReduction reduce:self usingBlock:f];
}


-(HMRRepetition *)repeat {
	return [HMRRepetition repeat:self];
}


#pragma mark HMRCombinator

-(HMRCombinator *)derivative:(id<NSObject,NSCopying>)object {
	return HMRNone();
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
	return ![[self derivative:object] isEqual:HMRNone()];
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
