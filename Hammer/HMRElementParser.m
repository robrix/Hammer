//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRElementParser.h"
#import "HMREmptyParser.h"
#import "HMRNullReductionParser.h"
#import "HMRParser+Protected.h"

@implementation HMRElementParser

+(instancetype)parserWithElement:(id)element {
	return [[self alloc] initWithElement:element];
}

-(instancetype)initWithElement:(id)element {
	if ((self = [super init])) {
		_element = element;
	}
	return self;
}


#pragma mark HammerParser

-(HMRParser *)derivativeWithRespectToElement:(id)element {
	return [self.element isEqual:element]?
		[HMRNullReductionParser parserWithElement:element]
	:	[HMREmptyParser parser];
}

@end
