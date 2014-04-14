//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRBlockCombinator.h"

@implementation HMRBlockCombinator

-(instancetype)initWithBlock:(REDPredicateBlock)block {
	if ((self = [super init])) {
		_block = [block copy];
	}
	return self;
}


#pragma mark HMRPredicateCombinator

-(bool)evaluateWithObject:(id)object {
	return self.block(object);
}


#pragma mark HMRTerminal

-(NSString *)describe {
	return @"^bool(id){…}";
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRBlockCombinator *)object {
	return
		[object isKindOfClass:self.class]
	&&	[self.block isEqual:object.block];
}

-(NSUInteger)hash {
	return
		@"HMRBlockCombinator".hash
	^	[self.block hash];
}

@end

