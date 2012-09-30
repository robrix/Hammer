//  HammerConcatenationParser.m
//  Created by Rob Rix on 2012-07-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerConcatenationParser.h"
#import "HammerEmptyParser.h"
#import "HammerMemoization.h"
#import "HammerNullReductionParser.h"

@implementation HammerConcatenationParser {
	HammerParser *_first;
	HammerParser *_second;
	HammerLazyParser _lazyFirst;
	HammerLazyParser _lazySecond;
}

+(instancetype)parserWithFirst:(HammerLazyParser)first second:(HammerLazyParser)second {
	HammerConcatenationParser *parser = [self new];
	parser->_lazyFirst = HammerMemoizingLazyParser(&(parser->_first), first);
	parser->_lazySecond = HammerMemoizingLazyParser(&(parser->_second), second);
	return parser;
}


-(HammerParser *)first {
	return _lazyFirst();
}

-(HammerParser *)second {
	return _lazySecond();
}


-(HammerParser *)parseDerive:(id)term {
	HammerLazyParser nulled = HammerDelay([HammerConcatenationParser parserWithFirst:HammerDelay([self.first parse:term]) second:_lazySecond]);
	return self.first.isNullable?
		[HammerAlternationParser parserWithLeft:HammerDelay([HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullReductionParser parserWithParseTrees:[self.first parseNull]]) second:HammerDelay([self.second parse:term])]) right:nulled]
	:	nulled();
}


-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	return [visitor concatenationParser:self withFirst:_lazyFirst second:_lazySecond];
}

@end
