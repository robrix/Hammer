//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRDelayCombinator.h"
#import "HMRNonterminal.h"

@interface HMRDelayCombinator ()

@property (readonly) id<HMRCombinator> forced;

@end

@implementation HMRDelayCombinator

-(instancetype)initWithBlock:(HMRDelayBlock)block {
	return [super initWithClass:[HMRNonterminal class] block:block];
}


@dynamic forced;


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivative:(id)object {
	return [self.forced derivative:object];
}


-(bool)isNullable {
	return self.forced.nullable;
}

-(bool)isCyclic {
	return self.forced.cyclic;
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

-(NSOrderedSet *)prettyPrinted {
	return self.forced.prettyPrinted;
}


-(NSString *)name {
	return self.forced.name;
}

-(instancetype)withName:(NSString *)name {
	return [self.forced withName:name];
}

@end


id<HMRCombinator> HMRLazyCombinator(id<HMRCombinator>(^block)(void)) {
	return [[HMRDelayCombinator alloc] initWithBlock:block];
}
