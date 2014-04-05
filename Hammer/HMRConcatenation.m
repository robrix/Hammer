//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRConcatenation.h"
#import "HMRNull.h"

@implementation HMRConcatenation

-(instancetype)initWithFirst:(id<HMRCombinator>)first second:(id<HMRCombinator>)second {
	if ((self = [super init])) {
		_first = [first copyWithZone:NULL];
		_second = [second copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	id<HMRCombinator> first = self.first;
	id<HMRCombinator> second = self.second;
	id<HMRCombinator> derivativeAfterFirst = HMRConcatenate([first derivative:object], second);
	return first.nullable?
		HMRAlternate(derivativeAfterFirst, HMRConcatenate(HMRCaptureForest(first.parseForest), [second derivative:object]))
	:	derivativeAfterFirst;
}

l3_test(@selector(derivative:)) {
	id first = @"a";
	id second = @"b";
	id other = @"";
	id<HMRCombinator> concatenation = HMRConcatenate(HMRLiteral(first), HMRLiteral(second));
	l3_expect([[concatenation derivative:first] derivative:second].parseForest).to.equal([NSSet setWithObject:@[ first, second ]]);
	l3_expect([[concatenation derivative:first] derivative:other].parseForest).to.equal([NSSet set]);
	
	id third = @"c";
	concatenation = HMRConcatenate(HMRLiteral(first), HMRConcatenate(HMRLiteral(second), HMRLiteral(third)));
	l3_expect([[[concatenation derivative:first] derivative:second] derivative:third].parseForest).to.equal([NSSet setWithObject:@[ first, second, third ]]);
}


-(bool)computeNullability {
	return self.first.nullable && self.second.nullable;
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
	if ([first isEqual:HMRNone()] || [second isEqual:HMRNone()])
		concatenation = HMRNone();
	else if ([first isKindOfClass:[HMRNull class]] && [second.parseForest isKindOfClass:[HMRNull class]])
		concatenation = HMRCaptureForest([HMRConcatenation concatenateParseForestWithPrefix:first.parseForest suffix:second.parseForest]);
	else if ([first isKindOfClass:[HMRNull class]] && [second isKindOfClass:[HMRConcatenation class]] && [((HMRConcatenation *)second).first isKindOfClass:[HMRNull class]])
		concatenation = HMRConcatenate(HMRCaptureForest([HMRConcatenation concatenateParseForestWithPrefix:first.parseForest suffix:((HMRConcatenation *)second).first.parseForest]), ((HMRConcatenation *)second).second);
	else
		concatenation = HMRConcatenate(first, second);
	return concatenation;
}

l3_test(@selector(compaction)) {
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = HMRNone();
	l3_expect(HMRConcatenate(empty, anything).compaction).to.equal(empty);
	l3_expect(HMRConcatenate(anything, empty).compaction).to.equal(empty);
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


id<HMRCombinator> HMRConcatenate(id<HMRCombinator> first, id<HMRCombinator> second) {
	NSCParameterAssert(first != nil);
	NSCParameterAssert(second != nil);
	
	return [[HMRConcatenation alloc] initWithFirst:first second:second];
}
