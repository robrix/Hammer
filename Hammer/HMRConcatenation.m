//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRConcatenation.h"
#import "HMRNull.h"

@implementation HMRConcatenation {
	HMRLazyCombinator _lazyFirst;
	id<HMRCombinator> _first;
	HMRLazyCombinator _lazySecond;
	id<HMRCombinator> _second;
}

-(instancetype)initWithFirst:(id<HMRCombinator>)first second:(id<HMRCombinator>)second {
	if ((self = [super init])) {
		_first = [first copyWithZone:NULL];
		_second = [second copyWithZone:NULL];
	}
	return self;
}

-(instancetype)initWithLazyFirst:(HMRLazyCombinator)lazyFirst lazySecond:(HMRLazyCombinator)lazySecond {
	if ((self = [super init])) {
		_lazyFirst = [lazyFirst copy];
		_lazySecond = [lazySecond copy];
	}
	return self;
}


-(id<HMRCombinator>)first {
	if (!_first) {
		_first = HMRForce(_lazyFirst);
		_lazyFirst = nil;
	}
	return _first;
}

-(id<HMRCombinator>)second {
	if (!_second) {
		_second = HMRForce(_lazySecond);
		_lazySecond = nil;
	}
	return _second;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	NSSet *forest = self.first.parseForest;
	id<HMRCombinator> derivativeAfterFirst = HMRConcatenate(HMRDelay([self.first derivative:object]), HMRDelay(self.second));
	return forest.count?
		HMRAlternate(HMRDelay(derivativeAfterFirst), HMRDelay(HMRConcatenate(HMRDelay(HMRCaptureForest(forest)), HMRDelay([self.second derivative:object]))))
	:	derivativeAfterFirst;
}

l3_test(@selector(derivative:)) {
	id first = @"a";
	id second = @"b";
	id other = @"";
	id<HMRCombinator> concatenation = HMRConcatenate(HMRDelay(HMRLiteral(first)), HMRDelay(HMRLiteral(second)));
	l3_expect([[concatenation derivative:first] derivative:second].parseForest).to.equal([NSSet setWithObject:@[ first, second ]]);
	l3_expect([[concatenation derivative:first] derivative:other].parseForest).to.equal([NSSet set]);
	
	id third = @"c";
	concatenation = HMRConcatenate(HMRDelay(HMRLiteral(first)), HMRDelay(HMRConcatenate(HMRDelay(HMRLiteral(second)), HMRDelay(HMRLiteral(third)))));
	l3_expect([[[concatenation derivative:first] derivative:second] derivative:third].parseForest).to.equal([NSSet setWithObject:@[ first, second, third ]]);
}


+(NSSet *)concatenateParseForestWithPrefix:(NSSet *)prefix suffix:(NSSet *)suffix {
	id(^concat)(id, id) = ^(id left, id right) {
		left = [left isKindOfClass:[NSArray class]]? left : @[ left ];
		right = [right isKindOfClass:[NSArray class]]? right : @[ right ];
		return [left arrayByAddingObjectsFromArray:right];
	};
	return [[NSSet set] red_append:REDFlattenMap(prefix, ^(id x) {
		return REDMap(suffix, ^(id y) {
			return concat(x, y);
		});
	})];
}

-(NSSet *)reduceParseForest {
	return [self.class concatenateParseForestWithPrefix:self.first.parseForest suffix:self.second.parseForest];
}


-(id<HMRCombinator>)compact {
	id<HMRCombinator> first = self.first.compaction;
	id<HMRCombinator> second = self.second.compaction;
	id<HMRCombinator> concatenation;
	if (first == HMRNone() || second == HMRNone())
		concatenation = HMRNone();
	else if ([first isKindOfClass:[HMRNull class]] && [second.parseForest isKindOfClass:[HMRNull class]])
		concatenation = HMRCaptureForest([HMRConcatenation concatenateParseForestWithPrefix:first.parseForest suffix:second.parseForest]);
	else if ([first isKindOfClass:[HMRNull class]] && [second isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)second).first isKindOfClass:[HMRNull class]])
		concatenation = HMRConcatenate(HMRDelay(HMRCaptureForest([HMRConcatenation concatenateParseForestWithPrefix:first.parseForest suffix:((HMRConcatenation *)second).first.parseForest])), HMRDelay(((HMRConcatenation *)second).second));
	else
		concatenation = [[self.class alloc] initWithFirst:first second:second];
	return concatenation;
}

l3_test(@selector(compaction)) {
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = HMRNone();
	l3_expect(HMRConcatenate(HMRDelay(empty), HMRDelay(anything)).compaction).to.equal(empty);
	l3_expect(HMRConcatenate(HMRDelay(anything), HMRDelay(empty)).compaction).to.equal(empty);
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"(%@ ∘ %@)", self.first.description, self.second.description];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRConcatenation *)object {
	return
		[object isKindOfClass:self.class]
	&&	[object.first isEqual:self.first]
	&&	[object.second isEqual:self.second];
}

@end


id<HMRCombinator> HMRConcatenate(HMRLazyCombinator lazyFirst, HMRLazyCombinator lazySecond) {
	return [[HMRConcatenation alloc] initWithLazyFirst:lazyFirst lazySecond:lazySecond];
}
