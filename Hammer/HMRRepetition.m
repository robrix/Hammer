//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRRepetition.h"

@implementation HMRRepetition

-(instancetype)initWithCombinator:(id<HMRCombinator>)combinator {
	if ((self = [super init])) {
		_combinator = [combinator copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return HMRConcatenate([self.combinator derivative:object], self);
}

l3_test(@selector(derivative:)) {
	id each = @"a";
	id<HMRCombinator> repetition = HMRRepeat(HMRLiteral(each));
	l3_expect([repetition derivative:each].parseForest).to.equal([NSSet setWithObject:@[ each ]]);
	l3_expect([[repetition derivative:each] derivative:each].parseForest).to.equal([NSSet setWithObject:@[ each, each ]]);
	l3_expect([[[repetition derivative:each] derivative:each] derivative:each].parseForest).to.equal([NSSet setWithObject:@[ each, each, each ]]);
	
	// S -> ("x" | S)*
	id terminal = @"x";
	__block id nonterminal = HMRDelay(^{ return HMRRepeat(HMRAlternate(HMRLiteral(terminal), nonterminal)); });
	l3_expect([nonterminal derivative:terminal].parseForest).to.equal([NSSet setWithObject:@[ terminal ]]);
}


-(NSSet *)reduceParseForest {
	return [NSSet setWithObject:@[]];
}

-(id<HMRCombinator>)compact {
	id<HMRCombinator> combinator = self.combinator.compaction;
	return [combinator isEqual:HMRNone()]?
		HMRCaptureTree(@[])
	:	HMRRepeat(combinator);
}

l3_test(@selector(compaction)) {
	l3_expect(HMRRepeat(HMRNone()).compaction).to.equal(HMRCaptureTree(@[]));
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@*", self.combinator.description];
}

@end


id<HMRCombinator> HMRRepeat(id<HMRCombinator> combinator) {
	return [[HMRRepetition alloc] initWithCombinator:combinator];
}

