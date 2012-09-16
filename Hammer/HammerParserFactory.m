//  HammerParserFactory.m
//  Created by Rob Rix on 2012-09-10.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "Hammer.h"
#import "HammerParserFactory.h"

@implementation HammerParserFactory

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
	return [HammerAlternationParser parserWithLeft:(id)left right:(id)right];
}

-(id)concatenationParserWithFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [HammerConcatenationParser parserWithFirst:(id)first second:(id)second];
}

-(id)reductionParserWithParser:(HammerLazyVisitable)parser function:(HammerReductionFunction)function {
	return [HammerReductionParser parserWithParser:(id)parser function:function];
}

@end
