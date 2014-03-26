//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLeastFixedPoint.h"
#import "HMRParserCombinator.h"

NSSet *HMRParseCollection(id<HMRCombinator> parser, id<NSFastEnumeration> collection) {
	for (id each in collection) {
		parser = [parser memoizedDerivativeWithRespectToElement:each];
	}
	return parser.parseForest;
}

l3_addTestSubjectTypeWithFunction(HMRParseCollection);
l3_test(&HMRParseCollection) {
	id element = @0;
	id<HMRCombinator> literal = HMRLiteral(element);
	l3_expect(HMRParseCollection(literal, @[ element ])).to.equal([NSSet setWithObject:element]);
	l3_expect(HMRParseCollection(literal, @[])).to.equal([NSSet set]);
	id anythingElse = @1;
	l3_expect(HMRParseCollection(literal, @[ anythingElse ])).to.equal([NSSet set]);
	
	l3_expect(HMRParseCollection(HMRConcatenate(literal, literal), @[ element, element ])).to.equal([NSSet setWithObject:@[element, element]]);
	
	id terminal = @"x";
	id nonterminalPrefix = @"+";
	// S -> "+" S | "x"
	__block id<HMRCombinator> nonterminal;
	nonterminal = HMRAlternate(HMRConcatenate(HMRLiteral(nonterminalPrefix), HMRDelay(^{ return nonterminal; })), HMRLiteral(terminal));
	l3_expect(HMRParseCollection(nonterminal, @[ terminal ])).to.equal([NSSet setWithObject:terminal]);
	l3_expect(HMRParseCollection(nonterminal, @[ nonterminalPrefix, terminal ])).to.equal([NSSet setWithObject:@[ nonterminalPrefix, terminal ]]);
	id nested = [NSSet setWithObject:@[ nonterminalPrefix, @[ nonterminalPrefix, terminal ] ]];
	l3_expect(HMRParseCollection(nonterminal, @[ nonterminalPrefix, nonterminalPrefix, terminal ])).to.equal(nested);
}


id<HMRCombinator> HMRParseElement(id<HMRCombinator> parser, id<NSObject, NSCopying> element) {
	return element?
		[parser memoizedDerivativeWithRespectToElement:element]
	:	nil; // ???
}


@implementation HMRParserCombinator {
	NSMutableDictionary *_derivativesByElements;
	NSSet *_parseForest;
	id<HMRCombinator> _compaction;
	NSString *_description;
}

-(instancetype)init {
	if ((self = [super init])) {
		_derivativesByElements = [NSMutableDictionary new];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
	return nil;
}

-(id<HMRCombinator>)memoizedDerivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
	return _derivativesByElements[element] ?: (_derivativesByElements[element] = [self derivativeWithRespectToElement:element].compaction);
}


-(NSSet *)reduceParseForest {
	return [NSSet set];
}

-(NSSet *)parseForest {
	return _parseForest ?: (_parseForest = HMRLeastFixedPoint([NSSet set], ^(NSSet *forest) {
		return _parseForest = [self reduceParseForest];
	}));
}


-(id<HMRCombinator>)compact {
	return self;
}

-(id<HMRCombinator>)compaction {
	return _compaction ?: (_compaction = [self compact]);
}


-(NSString *)describe {
	return super.description;
}

-(NSString *)description {
	return _description ?: (_description = [self describe]);
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}

@end
