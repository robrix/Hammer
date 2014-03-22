//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternationParser.h"
#import "HMRLazyParser.h"

@implementation HMRAlternationParser

+(instancetype)parserWithLeft:(HMRParser *)left right:(HMRParser *)right {
	return [[self alloc] initWithLeft:left right:right];
}

-(instancetype)initWithLeft:(HMRParser *)left right:(HMRParser *)right {
	if ((self = [super init])) {
		_left = [left copy];
		_right = [right copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(HMRParser *)derivativeWithRespectToElement:(id)element {
	Class class = self.class;
	HMRParser *left = self.left;
	HMRParser *right = self.right;
	return [HMRLazyParser parserWithBlock:^{
		return [class parserWithLeft:[left derivativeWithRespectToElement:element]
							   right:[right derivativeWithRespectToElement:element]];
	}];
}


-(NSSet *)deforest {
	return [[self.left deforest] setByAddingObjectsFromSet:[self.right deforest]];
}

@end
