//  HammerConcatenationParser.m
//  Created by Rob Rix on 2012-07-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerConcatenationParser.h"
#import "HammerMemoization.h"
#import "HammerNullReductionParser.h"

@implementation HammerConcatenationParser {
	HammerParser *_left;
	HammerParser *_right;
	HammerLazyParser _lazyLeft;
	HammerLazyParser _lazyRight;
}

+(instancetype)parserWithLeft:(HammerLazyParser)left right:(HammerLazyParser)right {
	HammerConcatenationParser *parser = [self new];
	parser->_lazyLeft = left;
	parser->_lazyRight = right;
	return parser;
}


-(HammerParser *)left {
	return HammerMemoizedValue(_left, HammerForce(_lazyLeft));
}

-(HammerParser *)right {
	return HammerMemoizedValue(_right, HammerForce(_lazyRight));
}


-(HammerParser *)parsePartial:(id)term {
	HammerLazyParser nulled = HammerDelay([HammerConcatenationParser parserWithLeft:HammerDelay([self.left parse:term]) right:_lazyRight]);
	return self.left.canParseNull?
		[HammerAlternationParser parserWithLeft:HammerDelay([HammerConcatenationParser parserWithLeft:HammerDelay([HammerNullReductionParser parserWithParseTrees:[self.left parseNull]]) right:HammerDelay([self.right parse:term])]) right:nulled]
	:	nulled();
}

-(NSSet *)parseNullRecursive {
	NSMutableSet *trees = [NSMutableSet set];
	for(id l in [self.left parseNull]) {
		for(id r in [self.right parseNull]) {
			// this is a really horrible cons cell, don’t do this
			[trees addObject:[NSArray arrayWithObjects:l, r, nil]];
		}
	}
	return trees;
}


-(BOOL)canParseNullRecursive {
	return self.left.canParseNull && self.right.canParseNull;
}


-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	NSMutableArray *childResults = nil;
	if ([visitor visitObject:self]) {
		childResults = [NSMutableArray new];
		id left = [self.left acceptVisitor:visitor];
		id right = [self.right acceptVisitor:visitor];
		if (left)
			[childResults addObject:left];
		if (right)
			[childResults addObject:right];
	}
	return [visitor leaveObject:self withVisitedChildren:childResults];
}

@end
