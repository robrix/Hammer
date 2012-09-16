//  HammerParserDescriptionVisitor.m
//  Created by Rob Rix on 2012-08-19.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerConcatenationParser.h"
#import "HammerEmptyParser.h"
#import "HammerNullParser.h"
#import "HammerNullReductionParser.h"
#import "HammerParserDescriptionVisitor.h"
#import "HammerRepetitionParser.h"
#import "HammerTermParser.h"

@implementation HammerParserDescriptionVisitor

-(id)visit:(HammerLazyVisitable)visitable {
	return [HammerForce(visitable) acceptAlgebra:self];
}


-(id)emptyParser {
	return @"∅";
}

-(id)nullParser {
	return @"ε";
}


-(id)nullReductionParserWithTrees:(NSSet *)trees {
	return [NSString stringWithFormat:@"ε↓{%@}", [trees.allObjects componentsJoinedByString:@", "]];
}


-(id)termParserWithTerm:(id)term {
	return [NSString stringWithFormat:@"'%@'", term];
}


-(id)alternationParserWithLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [NSString stringWithFormat:@"{%@ | %@}", [self visit:left], [self visit:right]];
}

-(id)concatenationParserWithFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [NSString stringWithFormat:@"(%@ %@)", [self visit:first], [self visit:second]];
}

-(id)reductionParserWithParser:(HammerLazyVisitable)parser function:(HammerReductionFunction)function {
	return [NSString stringWithFormat:@"%@ → %@", [self visit:parser], @"ƒ"];
}

@end
