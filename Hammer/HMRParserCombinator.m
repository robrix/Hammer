//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelay.h"
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
	nonterminal = HMRReduce(HMRAlternate(HMRConcatenate(HMRLiteral(nonterminalPrefix), HMRDelay(nonterminal)), HMRLiteral(terminal)), ^(id each) { return @[ each ]; });
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
	NSString *_description;
}

-(instancetype)init {
	if ((self = [super init])) {
		_derivativesByElements = [NSMutableDictionary new];
		
		__weak HMRParserCombinator *weakSelf = self;
		_compaction = HMRDelay([weakSelf compact]);
		
		_parseForest = HMRDelaySpecific([NSSet class], _parseForest = HMRLeastFixedPoint(_parseForest = [NSSet set], ^(NSSet *forest) {
			return _parseForest = [weakSelf reduceParseForest];
		}));
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return nil;
}

-(id<HMRCombinator>)derivative:(id<NSObject, NSCopying>)object {
	__weak HMRParserCombinator *weakSelf = self;
	return _derivativesByElements[object] ?: (_derivativesByElements[object] = HMRDelay(_derivativesByElements[object] = [weakSelf deriveWithRespectToObject:object].compaction));
}


-(NSSet *)reduceParseForest {
	return [NSSet set];
}

@synthesize parseForest = _parseForest;


-(id<HMRCombinator>)compact {
	return self;
}

@synthesize compaction = _compaction;


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
