//  HammerReductionParser.m
//  Created by Rob Rix on 2012-09-02.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerMemoization.h"
#import "HammerReductionParser.h"

@implementation HammerReductionParser {
	HammerParser *_parser;
	HammerLazyParser _lazyParser;
	HammerReductionFunction _function;
}

+(instancetype)parserWithParser:(HammerLazyParser)parser function:(HammerReductionFunction)function {
	NSParameterAssert(parser != nil);
	NSParameterAssert(function != nil);
	HammerReductionParser *reduction = [self new];
	reduction->_lazyParser = HammerMemoizingLazyParser(&reduction->_parser, parser);
	reduction->_function = function;
	return reduction;
}


-(HammerParser *)parser {
	return HammerMemoizedValue(_parser, HammerForce(_lazyParser));
}


-(HammerParser *)parse:(id)term {
	return [self.class parserWithParser:HammerDelay([self.parser parse:term]) function:_function];
}


-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	return [visitor reductionParser:self withParser:_lazyParser];
}

@end
