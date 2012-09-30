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

-(HammerParser *)derive:(HammerLazyVisitable)child {
	return [child() acceptVisitor:self];
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
	return [HammerAlternationParser parserWithLeft:HammerDelay([self derive:left]) right:HammerDelay([self derive:right])];
}

@end
