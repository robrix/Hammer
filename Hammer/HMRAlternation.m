//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMREmpty.h"
#import "HMRLazyCombinator.h"
#import "HMRLiteralCombinator.h"

@implementation HMRAlternation

+(instancetype)combinatorWithLeft:(id<HMRCombinator>)left right:(id<HMRCombinator>)right {
	return [[self alloc] initWithLeft:left right:right];
}

-(instancetype)initWithLeft:(id<HMRCombinator>)left right:(id<HMRCombinator>)right {
	if ((self = [super init])) {
		_left = [left copyWithZone:NULL];
		_right = [right copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	Class class = self.class;
	id<HMRCombinator> left = self.left;
	id<HMRCombinator> right = self.right;
	return [HMRLazyCombinator combinatorWithBlock:^{
		return [class combinatorWithLeft:[left derivative:object]
							   right:[right derivative:object]];
	}];
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
	id<HMRCombinator> compacted = [super compact];
	if (self.left.compaction == [HMREmpty empty])
		compacted = self.right.compaction;
	else if (self.right.compaction == [HMREmpty empty])
		compacted = self.left.compaction;
	return compacted;
}

l3_test(@selector(compaction)) {
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = [HMREmpty empty];
	l3_expect(HMRAlternate(empty, anything).compaction).to.equal(anything);
	l3_expect(HMRAlternate(anything, empty).compaction).to.equal(anything);
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@ | %@", self.left.description, self.right.description];
}

@end


id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right) {
	return [HMRAlternation combinatorWithLeft:left right:right];
}
