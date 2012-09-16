//  HammerAlternationParser.m
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerEmptyParser.h"
#import "HammerMemoization.h"

@implementation HammerAlternationParser {
	HammerParser *_left;
	HammerParser *_right;
	HammerLazyParser _lazyLeft;
	HammerLazyParser _lazyRight;
}

+(instancetype)parserWithLeft:(HammerLazyParser)left right:(HammerLazyParser)right {
	HammerAlternationParser *parser = [self new];
	parser->_lazyLeft = HammerMemoizingLazyParser(&parser->_left, left);
	parser->_lazyRight = HammerMemoizingLazyParser(&parser->_right, right);
	return parser;
}


-(HammerParser *)left {
	return _lazyLeft();
}

-(HammerParser *)right {
	return _lazyRight();
}


-(HammerParser *)parseDerive:(id)term {
	return [HammerAlternationParser parserWithLeft:HammerDelay([self.left parse:term]) right:HammerDelay([self.right parse:term])];
}

-(NSSet *)parseNullRecursive {
	NSMutableSet *trees = [NSMutableSet new];
	[trees unionSet:[self.left parseNull] ?: [NSSet set]];
	[trees unionSet:[self.right parseNull] ?: [NSSet set]];
	return trees;
}


-(BOOL)canParseNullRecursive {
	return self.left.canParseNull || self.right.canParseNull;
}


-(HammerParser *)compactRecursive {
	if ([self.left.compact isKindOfClass:[HammerEmptyParser class]])
		return self.right.compact;
	else if ([self.right.compact isKindOfClass:[HammerEmptyParser class]])
		return self.left.compact;
	else
		return [HammerAlternationParser parserWithLeft:HammerDelay(self.left.compact) right:HammerDelay(self.right.compact)];
}


-(id)acceptAlgebra:(id<HammerParserAlgebra>)algebra {
	return [algebra alternationParserWithLeft:_lazyLeft right:_lazyRight];
}

@end
