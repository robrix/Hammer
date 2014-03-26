//  HammerParserParseNullFunction.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerParserParseNullFunction.h"
#import "HammerLeastFixedPointVisitor.h"
#import <Hammer/Hammer.h>

@interface HammerParserParseNullFunction () <HammerVisitor>
@end

@implementation HammerParserParseNullFunction

+(instancetype)function {
	static HammerParserParseNullFunction *function = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		function = [self new];
	});
	return function;
}

+(NSSet *)parseNull:(HammerParser *)parser {
	return  [parser acceptVisitor:[[HammerLeastFixedPointVisitor alloc] initWithBottom:[NSSet set] visitor:[self function]]];
}

-(NSSet *)parseNull:(HammerLazyVisitable)child {
	return [child() acceptVisitor:self];
}


-(NSSet *)emptyParser:(HammerEmptyParser *)parser {
	return [NSSet set];
}

-(NSSet *)nullParser:(HammerNullParser *)parser {
	return [NSSet setWithObject:@""];
}

-(NSSet *)nullReductionParser:(HammerNullReductionParser *)parser {
	return parser.trees;
}


-(NSSet *)termParser:(HammerTermParser *)parser {
	return [NSSet set];
}


-(NSSet *)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	NSMutableSet *forest = [NSMutableSet new];
	[forest unionSet:[self parseNull:left]];
	[forest unionSet:[self parseNull:right]];
	return forest;
}

-(NSSet *)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	NSMutableSet *forest = [NSMutableSet new];
	for (id tree1 in [self parseNull:first]) {
		for (id tree2 in [self parseNull:second]) {
			[forest addObject:@[tree1, tree2]];
		}
	}
	return forest;
}

-(NSSet *)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	NSMutableSet *forest = [NSMutableSet new];
	for (id tree in [self parseNull:child]) {
		id reducedTree = parser.function(tree);
		if (reducedTree)
			[forest addObject:reducedTree];
	}
	return forest;
}

@end
