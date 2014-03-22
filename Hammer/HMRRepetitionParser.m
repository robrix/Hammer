//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRAlternationParser.h"
#import "HMRConcatenationParser.h"
#import "HMRLazyParser.h"
#import "HMRNullReductionParser.h"
#import "HMRReductionParser.h"
#import "HMRRepetitionParser.h"

@implementation HMRRepetitionParser

+(instancetype)parserWithParser:(HMRParser *)parser {
	return [[self alloc] initWithParser:parser];
}

-(instancetype)initWithParser:(HMRParser *)parser {
	if ((self = [super init])) {
		_parser = [parser copy];
	}
	return self;
}


#pragma mark HMRParser

-(HMRParser *)derivativeWithRespectToElement:(id)element {
	HMRParser *parser = self.parser;
	
	return [HMRLazyParser parserWithBlock:^{
		HMRConcatenationParser *concatenation = [HMRConcatenationParser parserWithFirst:[parser derivativeWithRespectToElement:element]
																				 second:self];
		HMRReductionParser *reduction = [HMRReductionParser parserWithParser:concatenation block:^(id x) {
			return x; // ??
		}];
		return [HMRAlternationParser parserWithLeft:reduction right:[HMRNullReductionParser parserWithElement:@[]]];
	}];
}


-(NSSet *)deforest {
	return [NSSet setWithObject:@[]];
}

@end
