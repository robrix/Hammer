//  HammerTermParser.m
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEmptyParser.h"
#import "HammerNullReductionParser.h"
#import "HammerTermParser.h"

@implementation HammerTermParser {
	id _term;
}

+(instancetype)parserWithTerm:(id)term {
	HammerTermParser *parser = [self new];
	parser->_term = term;
	return parser;
}


@synthesize term = _term;


-(HammerParser *)parse:(id)term {
	return [term isEqual:_term]?
		[HammerNullReductionParser parserWithParseTrees:[NSSet setWithObject:_term]]
	:	[HammerEmptyParser parser];
}

@end
