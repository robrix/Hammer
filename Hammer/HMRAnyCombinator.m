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


#pragma mark HMRPredicateCombinator

-(bool)evaluateWithObject:(id)object {
	return YES;
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}


#pragma mark NSObject

-(BOOL)isEqual:(id)object {
	return [self matchObject:object];
}

-(NSUInteger)hash {
	return @"HMRAny".hash;
}

@end


id HMRAny(void) {
	return HMROnce([HMRAnyCombinator new]);
}
