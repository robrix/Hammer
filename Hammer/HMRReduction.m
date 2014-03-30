//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRNull.h"
#import "HMRReduction.h"

@implementation HMRReduction

+(instancetype)combinatorWithParser:(id<HMRCombinator>)parser block:(HMRReductionBlock)block {
	return [[self alloc] initWithParser:parser block:block];
}

-(instancetype)initWithParser:(id<HMRCombinator>)parser block:(HMRReductionBlock)block {
	if ((self = [super init])) {
		_parser = [parser copyWithZone:NULL];
		_block = [block copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	id<HMRCombinator> parser = self.parser;
	HMRReductionBlock block = self.block;
	return HMRDelay(^{
		return HMRReduce([parser derivative:object], block);
	});
}


-(NSSet *)reduceParseForest {
	return [[NSSet set] red_append:REDMap(self.parser.parseForest, ^(id tree) {
		return self.block(tree);
	})];
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@ → 𝑓", self.parser.description];
}

@end


HMRReduction *HMRComposeReduction(HMRReduction *reduction, id<NSObject, NSCopying>(^g)(id<NSObject, NSCopying>)) {
	HMRReductionBlock f = reduction.block;
	return HMRReduce(reduction.parser, ^(id<NSObject, NSCopying> x) { return g(f(x)); });
}

id<HMRCombinator> HMRReduce(id<HMRCombinator> parser, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>)) {
	return [parser isKindOfClass:[HMRReduction class]]?
		HMRComposeReduction(parser, block)
	:	[HMRReduction combinatorWithParser:parser block:block];
}
