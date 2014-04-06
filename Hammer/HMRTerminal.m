//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRTerminal.h"

@implementation HMRTerminal

#pragma mark HMRCombinator

-(id<HMRCombinator>)derivative:(id<NSObject,NSCopying>)object {
	return self;
}


-(bool)isNullable {
	return NO;
}

-(bool)isCyclic {
	return NO;
}


-(NSSet *)parseForest {
	return [NSSet set];
}


-(instancetype)compaction {
	return self;
}


-(NSString *)describe {
	return super.description;
}

-(NSString *)description {
	return self.name?
		[NSString stringWithFormat:@"%@ -> %@", self.name, [self describe]]
	:	[self describe];
}

-(NSOrderedSet *)prettyPrinted {
	return self.name? [NSOrderedSet orderedSetWithObject:self.description] : [NSOrderedSet orderedSet];
}


@synthesize name = _name;

-(instancetype)withName:(NSString *)name {
	_name = name;
	return self;
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}


#pragma mark NSObject

-(BOOL)isEqual:(id)object {
	return [object isKindOfClass:self.class];
}

@end
