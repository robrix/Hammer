//  HammerParserDerivativeFunction.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerParserDerivativeFunction.h"
#import <Hammer/Hammer.h>

@interface HammerParserDerivativeFunction () <HammerVisitor>
@property (nonatomic, readonly) id term;
@end

@implementation HammerParserDerivativeFunction

-(instancetype)initWithTerm:(id)term {
	if ((self = [super init])) {
		_term = term;
	}
	return self;
}


+(HammerParser *)derivatativeOfParser:(HammerParser *)parser withRespectToTerm:(id)term {
	return [parser acceptVisitor:[[self alloc] initWithTerm:term]];
}

-(HammerLazyParser)derive:(HammerLazyVisitable)child {
	return HammerDelay([child() acceptVisitor:self]);
}


-(HammerParser *)emptyParser:(HammerEmptyParser *)parser {
	return parser;
}

-(HammerParser *)nullParser:(HammerNullParser *)parser {
	return [HammerEmptyParser parser];
}

-(HammerParser *)nullReductionParser:(HammerNullReductionParser *)parser {
	return [HammerEmptyParser parser];
}


-(HammerParser *)termParser:(HammerTermParser *)parser {
	return [parser.term isEqual:self.term]?
		[HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:self.term]]
	:	[HammerEmptyParser parser];
}


-(HammerParser *)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [HammerAlternationParser parserWithLeft:[self derive:left] right:[self derive:right]];
}

-(HammerParser *)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	HammerLazyParser parsedFirst = HammerDelay([HammerConcatenationParser parserWithFirst:[self derive:first] second:(HammerLazyParser)second]);
	HammerLazyParser nulledFirst = HammerDelay([HammerConcatenationParser parserWithFirst:HammerDelay([HammerNullReductionParser parserWithParseTrees:[parser.first parseNull]]) second:[self derive:second]]);
	return parser.first.isNullable?
		[HammerAlternationParser parserWithLeft:nulledFirst right:parsedFirst]
	:	parsedFirst();
}

-(HammerParser *)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return [HammerReductionParser parserWithParser:[self derive:child] function:parser.function];
}

@end
