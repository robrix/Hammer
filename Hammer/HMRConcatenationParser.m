//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternationParser.h"
#import "HMRConcatenationParser.h"
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
	return [HMRAlternationParser parserWithLeft:[HMRConcatenationParser parserWithFirst:[self.first derivativeWithRespectToElement:element] second:self.second] right:[HMRConcatenationParser parserWithFirst:[HMRNullabilityParser parserWithParser:self.first] second:[self.second derivativeWithRespectToElement:element]]];
}

@end
