//  HammerParserIsEqualPredicate.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerParserIsEqualPredicate.h"
#import "HammerParserZipper.h"
#import <Hammer/Hammer.h>

@interface HammerParserIsEqualPredicate () <HammerVisitor>
@end

@implementation HammerParserIsEqualPredicate

+(bool)isParser:(HammerParser *)parser1 equalToParser:(HammerParser *)parser2 {
	return [[self new] isParser:parser1 equalToParser:parser2];
}

-(bool)isParser:(HammerParser *)parser1 equalToParser:(HammerParser *)parser2 {
	__block bool isEqual = YES;
	[HammerParserZipper zip:@[parser1, parser2] block:^(NSArray *parsers, bool *stop) {
		id token1 = [[parsers objectAtIndex:0] acceptVisitor:self];
		id token2 = [[parsers objectAtIndex:1] acceptVisitor:self];
		if (!(isEqual = [token1 isEqual:token2]))
			*stop = YES;
	}];
	return isEqual;
}


-(HammerEmptyParser *)emptyParser:(HammerEmptyParser *)parser {
	return parser;
}

-(HammerNullParser *)nullParser:(HammerNullParser *)parser {
	return parser;
}

-(HammerNullReductionParser *)nullReductionParser:(HammerNullReductionParser *)parser {
	return parser;
}


-(HammerTermParser *)termParser:(HammerTermParser *)parser {
	return parser;
}


-(Class)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [parser class];
}

-(Class)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [parser class];
}

-(id)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return parser.function;
}

@end
