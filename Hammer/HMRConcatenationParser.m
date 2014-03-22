//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternationParser.h"
#import "HMRConcatenationParser.h"
#import "HMRLazyParser.h"
#import "HMRNullabilityParser.h"
#import "HMRParser+Protected.h"

@implementation HMRConcatenationParser

+(instancetype)parserWithFirst:(HMRParser *)first second:(HMRParser *)second {
	return [[self alloc] initWithFirst:first second:second];
}

-(instancetype)initWithFirst:(HMRParser *)first second:(HMRParser *)second {
	if ((self = [super init])) {
		_first = [first copy];
		_second = [second copy];
	}
	return self;
}


#pragma mark HMRParser

-(HMRParser *)derivativeWithRespectToElement:(id)element {
	Class class = self.class;
	HMRParser *first = self.first;
	HMRParser *second = self.second;
	return [HMRLazyParser parserWithBlock:^{
		HMRParser *left = [class parserWithFirst:[first derivativeWithRespectToElement:element]
														   second:second];
		HMRParser *right = [class parserWithFirst:[HMRNullabilityParser parserWithParser:first]
															second:[second derivativeWithRespectToElement:element]];
		return [HMRAlternationParser parserWithLeft:left right:right];
	}];
}

@end
