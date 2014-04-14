//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREqualCombinator.h"
#import "HMREmpty.h"

@implementation HMREqualCombinator

-(instancetype)initWithObject:(id<NSObject, NSCopying>)object {
	NSParameterAssert(object != nil);
	
	if ((self = [super init])) {
		_object = object;
	}
	return self;
}


#pragma mark HMRPredicateCombinator

-(bool)evaluateWithObject:(id)object {
	return
		self.object == object
	||	[self.object isEqual:object];
}


#pragma mark HMRTerminal

-(NSString *)describe {
	return [NSString stringWithFormat:@"'%@'", self.object];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMREqualCombinator *)object {
	return
		[super isEqual:object]
	&&	[self.object isEqual:object.object];
}

-(NSUInteger)hash {
	return
		@"HMREqualCombinator".hash
	^	self.object.hash;
}

@end


id<HMRCombinator> HMREqual(id<NSObject, NSCopying> object) {
	return [[HMREqualCombinator alloc] initWithObject:object];
}


REDPredicateBlock HMREqualPredicate(REDPredicateBlock object) {
	object = object ?: REDTruePredicateBlock;
	return [^ bool (HMREqualCombinator *combinator) {
		return
			[combinator isKindOfClass:[HMREqualCombinator class]]
		&&	object(combinator.object);
	} copy];
}
