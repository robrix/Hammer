//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelayCombinator.h"
#import "HMRParserCombinator.h"

@interface HMRDelayCombinator ()

@property (readonly) id<HMRCombinator> forced;

@end

@implementation HMRDelayCombinator

-(instancetype)initWithBlock:(HMRDelayBlock)block {
	return [super initWithClass:[HMRParserCombinator class] block:block];
}


@dynamic forced;


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivative:(id)object {
	return [self.forced derivative:object];
}


-(bool)isNullable {
	return self.forced.nullable;
}


-(NSSet *)parseForest {
	return self.forced.parseForest;
}

l3_test(@selector(parseForest)) {
	NSSet *forest = [NSSet setWithObject:@"a"];
	id<HMRCombinator> capture = HMRCaptureForest(forest);
	id<HMRCombinator> delayed = HMRDelay(capture);
	l3_expect(HMRDelaySpecific([NSSet class], delayed.parseForest)).to.equal(forest);
	l3_expect(forest).to.equal(delayed.parseForest);
}


-(id<HMRCombinator>)compaction {
	return self.forcing? self : self.forced.compaction;
}


@dynamic description;

@end


id<HMRCombinator> HMRLazyCombinator(id<HMRCombinator>(^block)(void)) {
	return [[HMRDelayCombinator alloc] initWithBlock:block];
}
