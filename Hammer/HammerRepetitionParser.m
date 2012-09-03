//  HammerRepetitionParser.m
//  Created by Rob Rix on 2012-08-04.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerConcatenationParser.h"
#import "HammerMemoization.h"
#import "HammerRepetitionParser.h"

@implementation HammerRepetitionParser {
	HammerParser *_parser;
	HammerLazyParser _lazyParser;
}

+(instancetype)parserWithParser:(HammerLazyParser)parser {
	HammerRepetitionParser *instance = [self new];
	instance->_lazyParser = parser;
	return instance;
}


-(HammerParser *)parser {
	return HammerMemoizedValue(_parser, HammerForce(_lazyParser));
}


-(HammerParser *)parse:(id)term {
	return [HammerConcatenationParser parserWithFirst:HammerDelay([self.parser parse:term]) second:HammerDelay(self)];
}

-(NSSet *)parseNull {
	return [NSSet setWithObject:[NSNull null]];
}


-(BOOL)canParseNull {
	return YES;
}


-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	id child = nil;
	if ([visitor visitObject:self]) {
		child = [self.parser acceptVisitor:visitor];
	}
	return [visitor leaveObject:self withVisitedChildren:child];
}

@end
