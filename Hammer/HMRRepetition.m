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
	id<HMRCombinator> combinator = self.combinator;
	
	return HMRConcatenate([combinator derivative:object], self);
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


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@*", self.combinator.description];
}

@end


id<HMRCombinator> HMRRepeat(id<HMRCombinator> combinator) {
	return combinator == HMRNone()?
		HMRCaptureTree(@[])
	:	[[HMRRepetition alloc] initWithCombinator:combinator];
}

l3_addTestSubjectTypeWithFunction(HMRRepeat)
l3_test(&HMRRepeat) {
	l3_expect(HMRRepeat(HMRNone())).to.equal(HMRCaptureTree(@[]));
}
