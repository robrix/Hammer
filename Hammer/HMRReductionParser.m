//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLazyParser.h"
#import "HMRParser+Protected.h"
#import "HMRReductionParser.h"

@implementation HMRReductionParser

+(instancetype)parserWithParser:(HMRParser *)parser block:(HMRReductionBlock)block {
	return [[self alloc] initWithParser:parser block:block];
}

-(instancetype)initWithParser:(HMRParser *)parser block:(HMRReductionBlock)block {
	if ((self = [super init])) {
		_parser = [parser copy];
		_block = [block copy];
	}
	return self;
}


#pragma mark HMRParser

-(HMRParser *)derivativeWithRespectToElement:(id)element {
	HMRParser *parser = self.parser;
	HMRReductionBlock block = self.block;
	return [HMRLazyParser parserWithBlock:^{
		return [HMRReductionParser parserWithParser:[parser derivativeWithRespectToElement:element] block:block];
	}];
}

@end
