//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMRBlockCombinator.h"
#import "HMRConcatenation.h"
#import "HMRNull.h"
#import "HMRPair.h"

@implementation HMRAlternation

+(instancetype)alternateLeft:(HMRCombinator *)left right:(HMRCombinator *)right {
	return [[self alloc] initWithLeft:left right:right];
}

-(instancetype)initWithLeft:(HMRCombinator *)left right:(HMRCombinator *)right {
	NSParameterAssert(left != nil);
	NSParameterAssert(right != nil);
	
	if ((self = [super init])) {
		_left = [left copyWithZone:NULL];
		_right = [right copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(HMRCombinator *)deriveWithRespectToObject:(id<NSObject,NSCopying>)object {
	HMRCombinator *left = self.left;
	HMRCombinator *right = self.right;
	return [[left derivative:object] or:[right derivative:object]];
}

l3_test(@selector(derivative:)) {
	HMRCombinator *a = HMREqual(@"a"), *b = HMREqual(@"b");
	l3_expect([[a or:b] derivative:@"a"].parseForest).to.equal([NSSet setWithObject:@"a"]);
	l3_expect([[a or:a] derivative:@"a"].parseForest).to.equal([NSSet setWithObjects:@"a", @"a", nil]);
}


-(NSSet *)reduceParseForest {
	return [self.left.parseForest setByAddingObjectsFromSet:self.right.parseForest];
}


-(HMRCombinator *)compact {
	HMRCombinator *compacted;
	HMRCombinator *left = self.left.compaction;
	HMRCombinator *right = self.right.compaction;
	if ([left isEqual:[HMRCombinator empty]])
		compacted = right;
	else if ([right isEqual:[HMRCombinator empty]])
		compacted = left;
	else if ([left isKindOfClass:[HMRNull class]] && [left isEqual:right])
		compacted = left;
	else if ([left isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)left).first isKindOfClass:[HMRNull class]] && [right isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)left).first isEqual:((HMRConcatenation *)right).first]) {
		HMRCombinator *alternation;
		HMRCombinator *innerLeft = ((HMRConcatenation *)left).second;
		HMRCombinator *innerRight = ((HMRConcatenation *)right).second;
		alternation = [innerLeft or:innerRight];
		compacted = [((HMRConcatenation *)left).first and:alternation];
	}
	else if (left == self.left && right == self.right)
		compacted = self;
	else
		compacted = [left or:right];
	return compacted;
}

l3_test(@selector(compaction)) {
	HMRCombinator *anything = HMREqual(@0);
	HMRCombinator *empty = [HMRCombinator empty];
	l3_expect([empty or:anything].compaction).to.equal(anything);
	l3_expect([anything or:empty].compaction).to.equal(anything);
	
	HMRCombinator *nullParse = HMRCaptureTree(@"a");
	HMRCombinator *same = HMRCaptureTree(@"a");
	HMRCombinator *p = HMREqual(@"p");
	l3_expect([nullParse or:same].compaction).to.equal(same);
	
	__block HMRCombinator *cyclic = [[[HMRCombinator empty] or:[[HMRCombinator empty] and:HMRDelay(cyclic)]] withName:@"S"];
	l3_expect(cyclic.compaction).to.equal([HMRCombinator empty]);
	
	cyclic = [[[nullParse and:p] or:[same and:HMRDelay(cyclic)]] withName:@"S"];
	HMRCombinator *derivative = [cyclic.compaction derivative:@"p"];
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


#pragma mark HMRAlternation

-(bool)matchObject:(id)object {
	return
		[self.left matchObject:object]
	||	[self.right matchObject:object];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRAlternation *)object {
	return
		[object isKindOfClass:self.class]
	&&	[self.left isEqual:object.left]
	&&	[self.right isEqual:object.right];
}

@end


id<HMRPredicate> HMRAlternated(id<HMRPredicate> left, id<HMRPredicate> right) {
	left = left ?: HMRAny();
	right = right ?: HMRAny();
	return [[HMRBlockCombinator alloc] initWithBlock:^bool (HMRAlternation *subject) {
		return
			[subject isKindOfClass:[HMRAlternation class]]
		&&	[left matchObject:subject.left]
		&&	[right matchObject:subject.right];
	}];
}
