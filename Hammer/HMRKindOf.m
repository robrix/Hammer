//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRKindOf.h"

@implementation HMRKindOf

+(instancetype)kindOfClass:(Class)targetClass {
	return [[self alloc] initWithTargetClass:targetClass];
}

-(instancetype)initWithTargetClass:(Class)targetClass {
	NSParameterAssert(targetClass != nil);
	
	if ((self = [super init])) {
		_targetClass = targetClass;
	}
	return self;
}


#pragma mark HMRPredicateCombinator

-(bool)evaluateWithObject:(id)object {
	return [object isKindOfClass:self.targetClass];
}


#pragma mark HMRTerminal

-(NSString *)describe {
	return [NSString stringWithFormat:@"@%@", self.targetClass];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRKindOf *)object {
	return
		[object isKindOfClass:self.class]
	&&	[self.targetClass isEqual:object.targetClass];
}

-(NSUInteger)hash {
	return
		@"HMRKindOf".hash
	^	self.targetClass.description.hash;
}

@end
