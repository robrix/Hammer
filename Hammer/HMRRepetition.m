//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRRepetition.h"

@implementation HMRRepetition {
	HMRLazyCombinator _lazyCombinator;
	id<HMRCombinator> _combinator;
}

-(instancetype)initWithCombinator:(id<HMRCombinator>)combinator {
	if ((self = [super init])) {
		_combinator = [combinator copyWithZone:NULL];
	}
	return self;
}

-(instancetype)initWithLazyCombinator:(HMRLazyCombinator)lazyCombinator {
	if ((self = [super init])) {
		_lazyCombinator = [lazyCombinator copy];
	}
	return self;
}


-(id<HMRCombinator>)combinator {
	if (!_combinator) {
		_combinator = HMRForce(_lazyCombinator);
		_lazyCombinator = nil;
	}
	return _combinator;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return HMRConcatenate(HMRDelay([self.combinator derivative:object]), HMRDelay(self));
}

l3_test(@selector(derivative:)) {
	id each = @"a";
	id<HMRCombinator> repetition = HMRRepeat(HMRDelay(HMRLiteral(each)));
	l3_expect([repetition derivative:each].parseForest).to.equal([NSSet setWithObject:@[ each ]]);
	l3_expect([[repetition derivative:each] derivative:each].parseForest).to.equal([NSSet setWithObject:@[ each, each ]]);
	l3_expect([[[repetition derivative:each] derivative:each] derivative:each].parseForest).to.equal([NSSet setWithObject:@[ each, each, each ]]);
	
	// S -> ("x" | S)*
	id terminal = @"x";
	__block HMRRepetition *nonterminal = HMRRepeat(HMRDelay(HMRAlternate(HMRDelay(HMRLiteral(terminal)), HMRDelay(nonterminal))));
	l3_expect([nonterminal derivative:terminal].parseForest).to.equal([NSSet setWithObject:@[ terminal ]]);
}


-(NSSet *)reduceParseForest {
	return [NSSet setWithObject:@[]];
}

-(id<HMRCombinator>)compact {
	id<HMRCombinator> combinator = self.combinator.compaction;
	return combinator == HMRNone()?
		HMRCaptureTree(@[])
	:	[[HMRRepetition alloc] initWithCombinator:combinator];
}

l3_test(@selector(compaction)) {
	l3_expect(HMRRepeat(HMRDelay(HMRNone())).compaction).to.equal(HMRCaptureTree(@[]));
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@*", self.combinator.description];
}

@end


id<HMRCombinator> HMRRepeat(HMRLazyCombinator lazyCombinator) {
	return [[HMRRepetition alloc] initWithLazyCombinator:lazyCombinator];
}

