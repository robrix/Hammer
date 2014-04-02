//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMRConcatenation.h"
#import "HMRNull.h"

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
	return HMRDelay(^{
		return HMRAlternate([left derivative:object], [right derivative:object]);
	});
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
	id<HMRCombinator> alternation;
	id<HMRCombinator> left = self.left.compaction;
	id<HMRCombinator> right = self.right.compaction;
	if ([left isEqual:HMRNone()])
		alternation = right;
	else if ([right isEqual:HMRNone()])
		alternation = left;
	else if ([left isKindOfClass:[HMRNull class]] && [left isEqual:right])
		alternation = left;
	else if ([left isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)left).first isKindOfClass:[HMRNull class]] && [right isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)left).first isEqual:((HMRConcatenation *)right).first])
		alternation = HMRConcatenate(((HMRConcatenation *)left).first, HMRAlternate(((HMRConcatenation *)left).second, ((HMRConcatenation *)right).second));
	else
		alternation = HMRAlternate(left, right);
	return alternation;
}

l3_test(@selector(compaction)) {
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = HMRNone();
	l3_expect(HMRAlternate(empty, anything).compaction).to.equal(anything);
	l3_expect(HMRAlternate(anything, empty).compaction).to.equal(anything);
	
	id<HMRCombinator> nullParse = HMRCaptureTree(@"a");
	id<HMRCombinator> same = HMRCaptureTree(@"a");
	id<HMRCombinator> p = HMRLiteral(@"p");
	id<HMRCombinator> q = HMRLiteral(@"q");
	l3_expect(HMRAlternate(nullParse, same).compaction).to.equal(same);
	l3_expect(HMRAlternate(HMRConcatenate(nullParse, p), HMRConcatenate(same, q)).compaction).to.equal(HMRConcatenate(nullParse, HMRAlternate(p, q)));
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"(%@ | %@)", self.left.description, self.right.description];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRAlternation *)object {
	return
		[object isKindOfClass:self.class]
	&&	[object.left isEqual:self.left]
	&&	[object.right isEqual:self.right];
}

@end


id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right) {
	return [[HMRAlternation alloc] initWithLeft:left right:right];
}
