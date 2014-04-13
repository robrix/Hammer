//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAnyCombinator.h"
#import "HMROnce.h"

@implementation HMRAnyCombinator

#pragma mark HMRCombinator

-(id<HMRCombinator>)derivative:(id<NSObject,NSCopying>)object {
	return HMRCaptureTree(object);
}


-(NSString *)describe {
	return @".";
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return YES;
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
	return [self matchObject:object];
}

@end


id HMRAny(void) {
	return HMROnce([HMRAnyCombinator new]);
}
