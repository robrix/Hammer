//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRCombinator.h"

@implementation HMRCombinator

-(HMRCombinator *)and:(HMRCombinator *)other {
	return HMRAnd((id<HMRCombinator>)self, (id<HMRCombinator>)other);
}

-(HMRCombinator *)or:(HMRCombinator *)other {
	return HMROr((id<HMRCombinator>)self, (id<HMRCombinator>)other);
}


-(HMRCombinator *)map:(HMRReductionBlock)f {
	return HMRMap((id<HMRCombinator>)self, f);
}


-(HMRCombinator *)repeat {
	return HMRRepeat((id<HMRCombinator>)self);
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivative:(id<NSObject,NSCopying>)object {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}


-(NSSet *)parseForest {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}


-(id<HMRCombinator>)compaction {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}


@synthesize name = _name;

-(instancetype)withName:(NSString *)name {
	if (!_name) _name = [name copy];
	return self;
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return ![[self derivative:object] isEqual:HMRNone()];
}

-(id<HMRCase>)then:(id (^)())block {
	return [HMRCase caseWithPredicate:self block:block];
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return block(initial, self);
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}


#pragma mark NSObject

-(BOOL)isEqual:(id)object {
	return [object isKindOfClass:self.class];
}

@dynamic description;
@dynamic hash;

@end
