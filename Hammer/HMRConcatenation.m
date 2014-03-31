//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRConcatenation.h"

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
	return HMRDelay(^{
		NSSet *forest = first.parseForest;
		id<HMRCombinator> derivativeAfterFirst = HMRConcatenate([first derivative:object], second);
		return forest.count?
			HMRAlternate(derivativeAfterFirst, HMRConcatenate(HMRCaptureForest(forest), [second derivative:object]))
		:	derivativeAfterFirst;
	});
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


+(NSSet *)concatenateParseForestWithPrefix:(NSSet *)prefix suffix:(NSSet *)suffix {
	id(^concat)(id, id) = ^(id car, id cdr) {
		return [cdr isKindOfClass:[NSArray class]]?
			[@[ car ] arrayByAddingObjectsFromArray:cdr]
		:	@[ car, cdr ];
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


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@ %@", self.first.description, self.second.description];
}

@end


id<HMRCombinator> HMRConcatenate(id<HMRCombinator> first, id<HMRCombinator> second) {
	return (first == HMRNone() || second == HMRNone())?
		HMRNone()
	:	[[HMRConcatenation alloc] initWithFirst:first second:second];
}

l3_addTestSubjectTypeWithFunction(HMRConcatenate)
l3_test(&HMRConcatenate) {
	id<HMRCombinator> anything = HMRLiteral(@0);
	id<HMRCombinator> empty = HMRNone();
	l3_expect(HMRConcatenate(empty, anything)).to.equal(empty);
	l3_expect(HMRConcatenate(anything, empty)).to.equal(empty);
}
