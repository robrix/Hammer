//  HammerParserCompactor.m
//  Created by Rob Rix on 2012-09-16.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerConcatenationParser.h"
#import "HammerEmptyParser.h"
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
	return [parser acceptVisitor:[self compactor]];
}


-(id)emptyParser {
	return [HammerEmptyParser parser];
}

-(id)nullParser {
	return [HammerNullParser parser];
}


-(id)nullReductionParserWithTrees:(NSSet *)trees {
	return [HammerNullReductionParser parserWithParseTrees:trees];
}


-(id)termParserWithTerm:(id)term {
	return [HammerTermParser parserWithTerm:term];
}


-(id)alternationParserWithLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [HammerAlternationParser parserWithLeft:[left() acceptVisitor:self] right:[right() acceptVisitor:self]];
}

-(id)concatenationParserWithFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [HammerConcatenationParser parserWithFirst:[first() acceptVisitor:self] second:[second() acceptVisitor:self]];
}

-(id)reductionParserWithParser:(HammerLazyVisitable)parser function:(HammerReductionFunction)function {
	return [HammerReductionParser parserWithParser:[parser() acceptVisitor:self] function:function];
}

@end
