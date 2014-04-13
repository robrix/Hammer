//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
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


-(NSString *)name {
	return self.forced.name;
}

-(id<HMRCombinator>)withName:(NSString *)name {
	return (id)[self.forced withName:name];
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return [self.forced matchObject:object];
}

-(id<HMRCase>)then:(id (^)())block {
	return [HMRCase caseWithPredicate:self.forced block:block];
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return [(id<REDReducible>)self.forced red_reduce:initial usingBlock:block];
}

@end


id<HMRCombinator> HMRLazyCombinator(id<HMRCombinator>(^block)(void)) {
	return [[HMRDelayCombinator alloc] initWithBlock:block];
}
