//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternation.h"
#import "HMRConcatenation.h"
#import "HMREmpty.h"
#import "HMRLazyCombinator.h"
#import "HMRReduction.h"
#import "HMRRepetition.h"

@implementation HMRRepetition

+(instancetype)combinatorWithParser:(id<HMRCombinator>)parser {
	return [[self alloc] initWithParser:parser];
}

-(instancetype)initWithParser:(id<HMRCombinator>)parser {
	if ((self = [super init])) {
		_parser = [parser copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	id<HMRCombinator> parser = self.parser;
	
	return HMRDelay(^{
		HMRConcatenation *concatenation = HMRConcatenate([parser derivative:object], self);
		HMRReduction *reduction = HMRReduce(concatenation, ^(id<NSObject,NSCopying> x) {
			return x;
		});
		return HMRAlternate(reduction, HMRCaptureTree(@[]));
	});
}

l3_test(@selector(derivative:)) {
	id each = @"a";
	id<HMRCombinator> repetition = HMRRepeat(HMRLiteral(each));
	l3_expect([repetition derivative:each].parseForest).to.equal([NSSet setWithObject:@[ each ]]);
}


-(NSSet *)reduceParseForest {
	return [NSSet setWithObject:@[]];
}


-(id<HMRCombinator>)compact {
	return self.parser.compaction == [HMREmpty empty]?
		HMRCaptureTree(@[])
	:	[super compact];
}

l3_test(@selector(compaction)) {
	l3_expect(HMRRepeat([HMREmpty empty]).compaction).to.equal(HMRCaptureTree(@[]));
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@*", self.parser.description];
}

@end


id<HMRCombinator> HMRRepeat(id<HMRCombinator> parser) {
	return [HMRRepetition combinatorWithParser:parser];
}
