//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMROnce.h"

@implementation HMREmpty

#pragma mark HMRCombinator

-(id<HMRCombinator>)derivative:(id<NSObject, NSCopying>)object {
	return self;
}


-(bool)isNullable {
	return NO;
}


-(NSSet *)parseForest {
	return [NSSet set];
}


-(instancetype)compaction {
	return self;
}


-(NSString *)description {
	return @"∅";
}


@synthesize name = _name;

-(instancetype)withName:(NSString *)name {
	HMREmpty *empty = [self.class new];
	empty->_name = name;
	return empty;
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}


#pragma mark NSObject

-(BOOL)isEqual:(HMREmpty *)object {
	return [object isKindOfClass:self.class];
}

@end


id<HMRCombinator> HMRNone(void) {
	return HMROnce((HMREmpty *)[[HMREmpty class] new]);
}
