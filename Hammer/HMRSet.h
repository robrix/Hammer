//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRSet <NSObject, NSCopying>

-(BOOL)hmr_containsObject:(id)object;

@end


@interface NSSet (HMRSet) <HMRSet>
@end

@interface NSOrderedSet (HMRSet) <HMRSet>
@end

@interface NSArray (HMRSet) <HMRSet>
@end

@interface NSCharacterSet (HMRSet) <HMRSet>
@end
