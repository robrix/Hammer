//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRIntersection.h"

@implementation HMRIntersection

+(instancetype)intersectLeft:(HMRCombinator *)left right:(HMRCombinator *)right {
	return [[self alloc] initWithLeft:left right:right];
}

-(instancetype)initWithLeft:(HMRCombinator *)left right:(HMRCombinator *)right {
	NSParameterAssert(left != nil);
	NSParameterAssert(right != nil);
	
	if ((self = [super init])) {
		_left = [left copy];
		_right = [right copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(HMRCombinator *)deriveWithRespectToObject:(id<NSObject,NSCopying>)object {
	return [[self.left derivative:object] and:[self.right derivative:object]];
}

l3_test(@selector(derivative:)) {
	HMRCombinator *a = [HMRCombinator literal:@"a"], *b = [HMRCombinator literal:@"b"];
	l3_expect([[a and:b] derivative:@"a"]).to.equal([HMRCombinator empty]);
}


-(HMRCombinator *)compact {
	HMRCombinator *compacted;
	HMRCombinator *left = self.left.compaction;
	HMRCombinator *right = self.right.compaction;
	if ([left isEqual:[HMRCombinator empty]] || [right isEqual:[HMRCombinator empty]])
		compacted = [HMRCombinator empty];
	else if ([left isKindOfClass:[HMRNull class]] && [right isKindOfClass:[HMRNull class]]) {
		NSMutableSet *intersection = [left.parseForest mutableCopy];
		[intersection intersectSet:right.parseForest];
		compacted = [HMRCombinator capture:intersection];
	}
	else if (left == self.left && right == self.right)
		compacted = self;
	else
		compacted = [left and:right];
	return compacted;
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"(%@ ∩ %@)", self.left.name ?: self.left.description, self.right.name ?: self.right.description];
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


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return
		[self.left matchObject:object]
	&&	[self.right matchObject:object];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRIntersection *)object {
	return
		[super isEqual:object]
	&&	[self.left isEqual:object.left]
	&&	[self.right isEqual:object.right];
}

@end


id<HMRPredicate> HMRIntersected(id<HMRPredicate> left, id<HMRPredicate> right) {
	left = left ?: HMRAny();
	right = right ?: HMRAny();
	return [[HMRBlockCombinator alloc] initWithBlock:^bool (HMRIntersection *subject) {
		return
			[subject isKindOfClass:[HMRIntersection class]]
		&&	[left matchObject:subject.left]
		&&	[right matchObject:subject.right];
	}];
}
