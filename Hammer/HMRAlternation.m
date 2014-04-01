//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMRConcatenation.h"
#import "HMRNull.h"

@implementation HMRAlternation {
	HMRLazyCombinator _lazyLeft;
	id<HMRCombinator> _left;
	HMRLazyCombinator _lazyRight;
	id<HMRCombinator> _right;
}

-(instancetype)initWithLeft:(id<HMRCombinator>)left right:(id<HMRCombinator>)right {
	if ((self = [super init])) {
		_left = [left copyWithZone:NULL];
		_right = [right copyWithZone:NULL];
	}
	return self;
}

-(instancetype)initWithLazyLeft:(HMRLazyCombinator)lazyLeft lazyRight:(HMRLazyCombinator)lazyRight {
	if ((self = [super init])) {
		_lazyLeft = [lazyLeft copy];
		_lazyRight = [lazyRight copy];
	}
	return self;
}


-(id<HMRCombinator>)left {
	if (!_left) {
		_left = HMRForce(_lazyLeft);
		_lazyLeft = nil;
	}
	return _left;
}

-(id<HMRCombinator>)right {
	if (!_right) {
		_right = HMRForce(_lazyRight);
		_lazyRight = nil;
	}
	return _right;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return HMRAlternate(HMRDelay([self.left derivative:object]), HMRDelay([self.right derivative:object]));
}

l3_test(@selector(derivative:)) {
	id<HMRCombinator> a = HMRLiteral(@"a"), b = HMRLiteral(@"b");
	HMRAlternation *(^alt)(id<HMRCombinator>, id<HMRCombinator>) = ^(id<HMRCombinator> a, id<HMRCombinator> b) {
		return [[HMRAlternation alloc] initWithLeft:a right:b];
	};
	l3_expect([alt(a, b) derivative:@"a"].parseForest).to.equal([NSSet setWithObject:@"a"]);
	l3_expect([alt(a, a) derivative:@"a"].parseForest).to.equal([NSSet setWithObjects:@"a", @"a", nil]);
}


-(NSSet *)reduceParseForest {
	return [self.left.parseForest setByAddingObjectsFromSet:self.right.parseForest];
}


-(id<HMRCombinator>)compact {
	id<HMRCombinator> alternation;
	id<HMRCombinator> left = self.left;
	id<HMRCombinator> right = self.right;
	if (left == HMRNone())
		alternation = right;
	else if (right == HMRNone())
		alternation = left;
	else if ([left isKindOfClass:[HMRNull class]] && [left isEqual:right])
		alternation = left;
	else if ([left isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)left).first isKindOfClass:[HMRNull class]] && [right isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)left).first isEqual:((HMRConcatenation *)right).first])
		alternation = HMRConcatenate(HMRDelay(((HMRConcatenation *)left).first), HMRDelay([[self.class alloc] initWithLeft:((HMRConcatenation *)left).second right:((HMRConcatenation *)right).second]));
	else
		alternation = [[self.class alloc] initWithLeft:left right:right];
	return alternation;
}

l3_test(@selector(compaction)) {
	HMRAlternation *(^alt)(id<HMRCombinator>, id<HMRCombinator>) = ^(id<HMRCombinator> a, id<HMRCombinator> b) {
		return [[HMRAlternation alloc] initWithLeft:a right:b];
	};
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = HMRNone();
	l3_expect(alt(empty, anything).compaction).to.equal(anything);
	l3_expect(alt(anything, empty).compaction).to.equal(anything);
	
	id<HMRCombinator> nullParse = HMRCaptureTree(@"a");
	id<HMRCombinator> same = HMRCaptureTree(@"a");
	id<HMRCombinator> p = HMRLiteral(@"p");
	id<HMRCombinator> q = HMRLiteral(@"q");
	l3_expect(alt(nullParse, same).compaction).to.equal(same);
	l3_expect(alt(HMRConcatenate(HMRDelay(nullParse), HMRDelay(p)), HMRConcatenate(HMRDelay(same), HMRDelay(q))).compaction).to.equal(HMRConcatenate(HMRDelay(nullParse), HMRDelay(alt(p, q))));
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@ | %@", self.left.description, self.right.description];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRAlternation *)object {
	return
		[object isKindOfClass:self.class]
	&&	[object.left isEqual:self.left]
	&&	[object.right isEqual:self.right];
}

@end


id<HMRCombinator> HMRAlternate(HMRLazyCombinator lazyLeft, HMRLazyCombinator lazyRight) {
	return [[HMRAlternation alloc] initWithLazyLeft:lazyLeft lazyRight:lazyRight];
}
