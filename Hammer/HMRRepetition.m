//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRBlockCombinator.h"
#import "HMRKVCCombinator.h"
#import "HMRPair.h"
#import "HMRRepetition.h"

@implementation HMRRepetition

+(instancetype)repeat:(HMRCombinator *)combinator {
	return [[self alloc] initWithCombinator:combinator];
}

-(instancetype)initWithCombinator:(HMRCombinator *)combinator {
	NSParameterAssert(combinator != nil);
	
	if ((self = [super init])) {
		_combinator = [combinator copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(HMRCombinator *)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return [[self.combinator derivative:object] concat:self];
}

l3_test(@selector(derivative:)) {
	id each = @"a";
	HMRCombinator *repetition = [[HMRCombinator literal:each] repeat];
	l3_expect([repetition derivative:each].parseForest).to.equal([NSSet setWithObject:HMRList(each, nil)]);
	l3_expect([[repetition derivative:each] derivative:each].parseForest).to.equal([NSSet setWithObject:HMRList(each, each, nil)]);
	l3_expect([[[repetition derivative:each] derivative:each] derivative:each].parseForest).to.equal([NSSet setWithObject:HMRList(each, each, each, nil)]);
	
	// S -> ("x" | S)*
	id terminal = @"x";
	__block id nonterminal = HMRDelay([[[HMRCombinator literal:terminal] or:nonterminal] repeat]);
	
	l3_expect([nonterminal derivative:terminal].parseForest).to.equal([NSSet setWithObject:HMRList(terminal, nil)]);
	l3_expect([[nonterminal derivative:terminal] derivative:terminal].parseForest).to.equal([NSSet setWithObject:HMRList(terminal, terminal, nil)]);
}


-(HMRCombinator *)compact {
	HMRCombinator *combinator = self.combinator.compaction;
	return [combinator isEqual:[HMRCombinator empty]]?
		[HMRCombinator captureTree:[HMRPair null]]
	:	(combinator == self.combinator? self : [combinator repeat]);
}

l3_test(@selector(compaction)) {
	l3_expect([[HMRCombinator empty] repeat].compaction).to.equal([HMRCombinator captureTree:[HMRPair null]]);
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@*", self.combinator.name ?: self.combinator.description];
}


-(NSUInteger)computeHash {
	return
		[super computeHash]
	^	self.combinator.hash;
}


-(id)reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return [self.combinator red_reduce:[super reduce:initial usingBlock:block] usingBlock:block];
}


-(HMRCombinator *)quote {
	return [[super quote] and:[HMRKVCCombinator keyPath:@"combinator" combinator:self.combinator]];
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return [self.combinator matchObject:object] || YES;
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRRepetition *)object {
	return
		[object isKindOfClass:self.class]
	&&	[self.combinator isEqual:object.combinator];
}

@end


id<HMRPredicate> HMRRepeated(id<HMRPredicate> combinator) {
	combinator = combinator ?: HMRAny();
	return [[HMRBlockCombinator alloc] initWithBlock:^bool (HMRRepetition *subject) {
		return
			[subject isKindOfClass:[HMRRepetition class]]
		&&	[combinator matchObject:subject.combinator];
	}];
}
