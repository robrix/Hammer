//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRSet.h"

@implementation NSSet (HMRSet)

-(BOOL)hmr_containsObject:(id)object {
	return [self containsObject:object];
}

@end

@implementation NSOrderedSet (HMRSet)

-(BOOL)hmr_containsObject:(id)object {
	return [self containsObject:object];
}

@end

@implementation NSArray (HMRSet)

-(BOOL)hmr_containsObject:(id)object {
	return [self containsObject:object];
}

@end

@implementation NSCharacterSet (HMRSet)

-(BOOL)hmr_containsObject:(NSString *)object {
	return
		[object isKindOfClass:[NSString class]]
	&&	[object rangeOfCharacterFromSet:self].length > 0;
}

l3_test(@selector(hmr_containsObject:)) {
	l3_expect([[NSCharacterSet whitespaceAndNewlineCharacterSet] hmr_containsObject:@" "]).to.equal(@YES);
	l3_expect([[NSCharacterSet alphanumericCharacterSet] hmr_containsObject:@" "]).to.equal(@NO);
}

@end
