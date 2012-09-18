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


-(id)emptyParser:(HammerEmptyParser *)parser {
	return parser;
}

-(id)nullParser:(HammerNullParser *)parser {
	return parser;
}


-(id)nullReductionParser:(HammerNullReductionParser *)parser {
	return parser;
}


-(id)termParser:(HammerTermParser *)parser {
	return parser;
}


-(id)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [HammerAlternationParser parserWithLeft:[left() acceptVisitor:self] right:[right() acceptVisitor:self]];
}

-(id)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [HammerConcatenationParser parserWithFirst:[first() acceptVisitor:self] second:[second() acceptVisitor:self]];
}

-(id)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return [HammerReductionParser parserWithParser:[child() acceptVisitor:self] function:parser.function];
}

@end
