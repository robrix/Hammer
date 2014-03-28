//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLazyCombinator.h"
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
	return [HMRLazyCombinator combinatorWithBlock:^{
		return [HMRReduction combinatorWithParser:[parser derivative:object] block:block];
	}];
}


-(NSSet *)reduceParseForest {
	NSMutableSet *trees = [NSMutableSet new];
	for (id each in self.parser.parseForest) {
		[trees addObject:self.block(each)];
	}
	return trees;
}


-(id<HMRCombinator>)compact {
	id<HMRCombinator> compacted = [super compact];
	if ([self.parser.compaction isKindOfClass:[HMRNull class]])
		compacted = HMRCaptureForest(self.parseForest);
	else if ([self.parser.compaction isKindOfClass:self.class]) {
		HMRReductionBlock f = ((HMRReduction *)self.parser.compaction).block;
		HMRReductionBlock g = self.block;
		compacted = [HMRReduction combinatorWithParser:self.parser.compaction block:^(id<NSObject,NSCopying> x) {
			return g(f(x));
		}];
	}
	return compacted;
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"%@ → 𝑓", self.parser.description];
}

@end


id<HMRCombinator> HMRReduce(id<HMRCombinator> parser, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>)) {
	return [HMRReduction combinatorWithParser:parser block:block];
}
