//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRTerminal.h"

@implementation HMRTerminal

#pragma mark HMRCombinator

-(id<HMRCombinator>)derivative:(id<NSObject,NSCopying>)object {
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


-(NSString *)describe {
	return super.description;
}

-(NSString *)description {
	return self.name?
		[NSString stringWithFormat:@"%@ -> %@", self.name, [self describe]]
	:	[self describe];
}


@synthesize name = _name;

-(instancetype)withName:(NSString *)name {
	if (!_name) _name = [name copy];
	return self;
}


@dynamic hash;


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return [self isEqual:object];
}

-(id<HMRCase>)then:(id (^)())block {
	return [HMRCase caseWithPredicate:self block:block];
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return block(initial, self);
}

l3_test(@selector(red_reduce:usingBlock:)) {
	HMRTerminal *terminal = (HMRTerminal *)HMREqual(@"x");
	NSNumber *count = [terminal red_reduce:@0 usingBlock:^(NSNumber *into, HMRTerminal *each) {
		return @(into.integerValue + 1);
	}];
	l3_expect(count).to.equal(@1);
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
