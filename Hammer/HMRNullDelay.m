//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRNull.h"
#import "HMRNullDelay.h"

@implementation HMRNullDelay {
	NSSet *parseForest;
}

+(Class)delayedClass {
	return [HMRNull class];
}


-(id<HMRCombinator>)compaction {
	return self;
}


-(id<HMRCombinator>)derivative:(id<NSObject,NSCopying>)object {
	return HMRNone();
}

-(bool)isNullable {
	return YES;
}


@synthesize parseForest = _parseForest;

-(NSSet *)parseForest {
	return _parseForest ?: ((_parseForest = [NSSet set]), (_parseForest = [self.forced parseForest]));
}


-(NSString *)name {
	return nil;
}

-(NSString *)description {
	return @"ε";
}

-(NSOrderedSet *)prettyPrinted {
	return [NSOrderedSet orderedSet];
}


-(BOOL)isKindOfClass:(Class)class {
	return [self.class isKindOfClass:class];
}


-(BOOL)isEqual:(id)object {
	return
		[object isKindOfClass:self.class]
	&&	[super isEqual:object];
}

@end
