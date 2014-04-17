//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLiteral.h"
#import "HMREmpty.h"

@implementation HMRLiteral

+(instancetype)literal:(id)object {
	return [[HMRLiteral alloc] initWithObject:object];
}

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

-(BOOL)isEqual:(HMRLiteral *)object {
	return
		[super isEqual:object]
	&&	[self.object isEqual:object.object];
}

-(NSUInteger)hash {
	return
		@"HMRLiteral".hash
	^	self.object.hash;
}

@end
