//  HammerParserCompactor.m
//  Created by Rob Rix on 2012-09-16.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerConcatenationParser.h"
#import "HammerEmptyParser.h"
#import "HammerIdentitySymbolizer.h"
#import "HammerMemoizingVisitor.h"
#import "HammerNullParser.h"
#import "HammerNullReductionParser.h"
#import "HammerParserCompactor.h"
#import "HammerReductionParser.h"
#import "HammerTermParser.h"

@interface HammerParserCompactor () <HammerVisitor>
@end

@implementation HammerParserCompactor

+(HammerParserCompactor *)compactor {
	static HammerParserCompactor *compactor = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		compactor = [self new];
	});
	return compactor;
}

+(HammerParser *)compact:(HammerParser *)parser {
	return [parser acceptVisitor:[[HammerMemoizingVisitor alloc] initWithVisitor:[self compactor] symbolizer:[HammerIdentitySymbolizer symbolizer]]];
}


-(HammerParser *)compact:(HammerLazyVisitable)child {
	return [child() acceptVisitor:self];
}


-(HammerParser *)compactParser:(HammerParser *)parser block:(HammerParser *(^)())block {
	HammerParser *compacted = nil;
	if (parser.isEmpty)
		compacted = [HammerEmptyParser parser];
	else if (parser.isNull)
		compacted = [[HammerNullReductionParser parserWithParseTrees:parser.parseNull] acceptVisitor:self];
	else
		compacted = block();
	return compacted;
}


-(HammerEmptyParser *)emptyParser:(HammerEmptyParser *)parser {
	return parser;
}

-(HammerNullParser *)nullParser:(HammerNullParser *)parser {
	return parser;
}


-(HammerParser *)nullReductionParser:(HammerNullReductionParser *)parser {
	return (parser.trees.count == 0)?
		[HammerNullParser parser]
	:	parser;
}


-(HammerTermParser *)termParser:(HammerTermParser *)parser {
	return parser;
}


-(HammerParser *)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [self compactParser:parser block:^HammerParser *{
		if ([self compact:left].isEmpty)
			return [self compact:right];
		else if ([self compact:right].isEmpty)
			return [self compact:left];
		else
			return [HammerAlternationParser parserWithLeft:HammerDelay([self compact:left]) right:HammerDelay([self compact:right])];
	}];
}

-(HammerParser *)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [self compactParser:parser block:^HammerParser *{
		if ([self compact:first].isEmpty || [self compact:second].isEmpty)
			return [HammerEmptyParser parser];
		else
			return [HammerConcatenationParser parserWithFirst:HammerDelay([self compact:first]) second:HammerDelay([self compact:second])];
	}];
}

-(HammerParser *)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return [self compactParser:parser block:^HammerParser *{
		if ([self compact:child].isEmpty)
			return [HammerEmptyParser parser];
		else
			return [HammerReductionParser parserWithParser:HammerDelay([self compact:child]) function:parser.function];
	}];
}

@end
