//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLeastFixedPoint.h"
#import "HMRParserCombinator.h"

NSSet *HMRParseCollection(id<HMRCombinator> parser, id<REDReducible> reducible) {
	parser = [reducible red_reduce:parser usingBlock:^(id<HMRCombinator> parser, id each) {
		return [parser derivative:each];
	}];
	return parser.parseForest;
}

l3_addTestSubjectTypeWithFunction(HMRParseCollection);
l3_test(&HMRParseCollection) {
	id object = @0;
	id<HMRCombinator> literal = HMRLiteral(object);
	l3_expect(HMRParseCollection(literal, @[ object ])).to.equal([NSSet setWithObject:object]);
	l3_expect(HMRParseCollection(literal, @[])).to.equal([NSSet set]);
	id anythingElse = @1;
	l3_expect(HMRParseCollection(literal, @[ anythingElse ])).to.equal([NSSet set]);
	
	l3_expect(HMRParseCollection(HMRConcatenate(literal, literal), @[ object, object ])).to.equal([NSSet setWithObject:@[object, object]]);
	
	id terminal = @"x";
	id nonterminalPrefix = @"+";
	// S -> "+" S | "x"
	__block id<HMRCombinator> nonterminal;
	nonterminal = HMRReduce(HMRAlternate(HMRConcatenate(HMRLiteral(nonterminalPrefix), HMRDelay(^{ return nonterminal; })), HMRLiteral(terminal)), ^(id each) { return @[ each ]; });
	l3_expect(HMRParseCollection(nonterminal, @[ terminal ])).to.equal([NSSet setWithObject:@[ terminal ]]);
	l3_expect(HMRParseCollection(nonterminal, @[ nonterminalPrefix, terminal ])).to.equal([NSSet setWithObject:@[ @[ nonterminalPrefix, terminal ] ]]);
	id nested = [NSSet setWithObject:@[ @[ nonterminalPrefix, @[ nonterminalPrefix, terminal ] ] ]];
	l3_expect(HMRParseCollection(nonterminal, @[ nonterminalPrefix, nonterminalPrefix, terminal ])).to.equal(nested);
}


id<HMRCombinator> HMRParseObject(id<HMRCombinator> parser, id<NSObject, NSCopying> object) {
	return object?
		[parser derivative:object]
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

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return nil;
}

-(id<HMRCombinator>)derivative:(id<NSObject, NSCopying>)object {
	return _derivativesByElements[object] ?: (_derivativesByElements[object] = [self deriveWithRespectToObject:object].compaction);
}


-(NSSet *)reduceParseForest {
	return [NSSet set];
}

-(NSSet *)parseForest {
	return _parseForest ?: (_parseForest = HMRLeastFixedPoint(_parseForest = [NSSet set], ^(NSSet *forest) {
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
