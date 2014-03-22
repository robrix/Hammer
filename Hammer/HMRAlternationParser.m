//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternationParser.h"
#import "HMRParser+Protected.h"

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


#pragma mark HMRParser

-(HMRParser *)derivativeWithRespectToElement:(id)element {
	return [self.class parserWithLeft:[self.left derivativeWithRespectToElement:element] right:[self.right derivativeWithRespectToElement:element]];
}

@end
