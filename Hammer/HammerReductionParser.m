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

-(NSSet *)parseNull {
	NSMutableSet *trees = [NSMutableSet new];
	for (id tree in self.parser.parseNull) {
		id newTree = _function(tree);
		if (newTree)
			[trees addObject:newTree];
	}
	return trees;
}


-(BOOL)canParseNull {
	return self.parser.canParseNull;
}


-(id)acceptVisitor:(id<HammerVisitor>)algebra {
	return [algebra reductionParserWithParser:_lazyParser function:_function];
}

@end
