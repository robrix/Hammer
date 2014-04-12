//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLiteralCombinator.h"
#import "HMREmpty.h"

@implementation HMRLiteralCombinator

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

-(BOOL)isEqual:(HMRLiteralCombinator *)object {
	return
		[super isEqual:object]
	&&	[object.object isEqual:self.object];
}

@end


id<HMRCombinator> HMRLiteral(id<NSObject, NSCopying> object) {
	return [[HMRLiteralCombinator alloc] initWithObject:object];
}
