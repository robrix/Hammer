//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLiteralCombinator.h"
#import "HMREmpty.h"
#import "HMRNullReduction.h"

@implementation HMRLiteralCombinator

+(instancetype)combinatorWithElement:(id<NSObject, NSCopying>)element {
	return [[self alloc] initWithElement:element];
}

-(instancetype)initWithElement:(id<NSObject, NSCopying>)element {
	NSParameterAssert(element != nil);
	
	if ((self = [super init])) {
		_element = element;
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)element {
	return [self.element isEqual:element]?
		[HMRNullReduction combinatorWithElement:element]
	:	[HMREmpty empty];
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"'%@'", self.element];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRLiteralCombinator *)object {
	return
		[object isKindOfClass:self.class]
	&&	[object.element isEqual:self.element];
}

@end


id<HMRCombinator> HMRLiteral(id<NSObject, NSCopying> element) {
	return [HMRLiteralCombinator combinatorWithElement:element];
}
