//  HammerAlternationParser.m
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerEmptyParser.h"
#import "HammerMemoization.h"

//typedef HammerParser *(^HammerParserDelay)();
//typedef HammerParserDelay(^HammerParserConstructor)(HammerParserDelay delay);
//
//id U(id(^f)(id)) {
//	return f(f);
//}
//
//id Z(id(^f)(id(^)())) {
//	return U(^(id x){
//		return f(^(id v){
//			return ((id(^)(id))U(x))(v);
//		});
//	});
//}
//
//HammerParser *HammerConstructParser(HammerParserConstructor constructor) {
//	HammerParserDelay delay = Z((id(^)())constructor);
//	return delay();
//}
//
//HammerAlternationParser *leftRecursiveAlternationWithRHS(HammerParser *rhs) {
//	HammerParserDelay delay = Z(^(HammerParserDelay lhs){
//		return (id)HammerDelay([HammerAlternationParser parserWithLeft:lhs right:HammerDelay(rhs)]);
//	});
//	return (HammerAlternationParser *)delay();
//}

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
