//  HammerAlternationParser.m
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerMemoization.h"

@implementation HammerAlternationParser {
	HammerParser *_left;
	HammerParser *_right;
	HammerLazyParser _lazyLeft;
	HammerLazyParser _lazyRight;
}

+(instancetype)parserWithLeft:(HammerLazyParser)left right:(HammerLazyParser)right {
	HammerAlternationParser *parser = [self new];
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
