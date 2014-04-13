//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMRConcatenation.h"
#import "HMRNull.h"
#import "HMRPair.h"

@implementation HMRAlternation

-(instancetype)initWithLeft:(id<HMRCombinator>)left right:(id<HMRCombinator>)right {
	if ((self = [super init])) {
		_left = [left copyWithZone:NULL];
		_right = [right copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	id<HMRCombinator> left = self.left;
	id<HMRCombinator> right = self.right;
	return HMRAlternate([left derivative:object], [right derivative:object]);
}

l3_test(@selector(derivative:)) {
	id<HMRCombinator> a = HMRLiteral(@"a"), b = HMRLiteral(@"b");
	l3_expect([HMRAlternate(a, b) derivative:@"a"].parseForest).to.equal([NSSet setWithObject:@"a"]);
	l3_expect([HMRAlternate(a, a) derivative:@"a"].parseForest).to.equal([NSSet setWithObjects:@"a", @"a", nil]);
}


-(NSSet *)reduceParseForest {
	return [self.left.parseForest setByAddingObjectsFromSet:self.right.parseForest];
}


-(id<HMRCombinator>)compact {
	id<HMRCombinator> compacted;
	id<HMRCombinator> left = self.left.compaction;
	id<HMRCombinator> right = self.right.compaction;
	if ([left isEqual:HMRNone()])
		compacted = right;
	else if ([right isEqual:HMRNone()])
		compacted = left;
	else if ([left isKindOfClass:[HMRNull class]] && [left isEqual:right])
		compacted = left;
	else if ([left isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)left).first isKindOfClass:[HMRNull class]] && [right isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)left).first isEqual:((HMRConcatenation *)right).first]) {
		id<HMRCombinator> alternation;
		id<HMRCombinator> innerLeft = ((HMRConcatenation *)left).second;
		id<HMRCombinator> innerRight = ((HMRConcatenation *)right).second;
		alternation = HMRAlternate(innerLeft, innerRight);
		compacted = HMRConcatenate(((HMRConcatenation *)left).first, alternation);
	}
	else if (left == self.left && right == self.right)
		compacted = self;
	else
		compacted = HMRAlternate(left, right);
	return compacted;
}

l3_test(@selector(compaction)) {
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = HMRNone();
	l3_expect(HMRAlternate(empty, anything).compaction).to.equal(anything);
	l3_expect(HMRAlternate(anything, empty).compaction).to.equal(anything);
	
	id<HMRCombinator> nullParse = HMRCaptureTree(@"a");
	id<HMRCombinator> same = HMRCaptureTree(@"a");
	id<HMRCombinator> p = HMRLiteral(@"p");
	l3_expect(HMRAlternate(nullParse, same).compaction).to.equal(same);
	
	__block id<HMRCombinator> cyclic = [HMRAlternate(HMRNone(), HMRConcatenate(HMRNone(), HMRDelay(cyclic))) withName:@"S"];
	l3_expect(cyclic.compaction).to.equal(HMRNone());
	
	cyclic = [HMRAlternate(HMRConcatenate(nullParse, p), HMRConcatenate(same, HMRDelay(cyclic))) withName:@"S"];
	id<HMRCombinator> derivative = [cyclic.compaction derivative:@"p"];
	l3_expect(derivative.parseForest).to.equal([NSSet setWithObject:HMRCons(@"a", @"p")]);
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"(%@ | %@)", self.left.name ?: self.left.description, self.right.name ?: self.right.description];
}


-(NSUInteger)computeHash {
	return
		[super computeHash]
	^	self.left.hash
	^	self.right.hash;
}


-(id)reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return [self.right red_reduce:[self.left red_reduce:[super reduce:initial usingBlock:block] usingBlock:block] usingBlock:block];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRAlternation *)object {
	return
		[object isKindOfClass:self.class]
	&&	[self.left isEqual:object.left]
	&&	[self.right isEqual:object.right];
}

@end


id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right) {
	NSCParameterAssert(left != nil);
	NSCParameterAssert(right != nil);
	
	return [[HMRAlternation alloc] initWithLeft:left right:right];
}


REDPredicateBlock HMRAlternationPredicate(REDPredicateBlock left, REDPredicateBlock right) {
	left = left ?: REDTruePredicateBlock;
	right = right ?: REDTruePredicateBlock;
	
	return [^bool (HMRAlternation *combinator) {
		return
			[combinator isKindOfClass:[HMRAlternation class]]
		&&	left(combinator.left)
		&&	right(combinator.right);
	} copy];
}
