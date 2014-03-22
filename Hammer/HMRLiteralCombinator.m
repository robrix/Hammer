//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLiteralCombinator.h"
#import "HMREmpty.h"
#import "HMRNullReduction.h"

@implementation HMRLiteralCombinator

+(instancetype)combinatorWithElement:(id)element {
	return [[self alloc] initWithElement:element];
}

-(instancetype)initWithElement:(id)element {
	if ((self = [super init])) {
		_element = element;
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id)element {
	return [self.element isEqual:element]?
		[HMRNullReduction combinatorWithElement:element]
	:	[HMREmpty parser];
}

@end
