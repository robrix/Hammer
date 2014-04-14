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
	&&	[object red_reduce:@YES usingBlock:^(NSNumber *into, NSString *each) {
			return @(into.boolValue && [self characterIsMember:[each characterAtIndex:0]]);
		}];
}

@end
