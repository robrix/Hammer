//  HammerParserFormatter.m
//  Created by Rob Rix on 2012-08-19.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerConcatenationParser.h"
#import "HammerEmptyParser.h"
#import "HammerNullParser.h"
#import "HammerNullReductionParser.h"
#import "HammerParserFormatter.h"
#import "HammerReductionParser.h"
#import "HammerTermParser.h"

@implementation HammerParserFormatter

-(id)visit:(HammerLazyVisitable)visitable {
	return [HammerForce(visitable) acceptVisitor:self];
}


-(id)emptyParser:(HammerEmptyParser *)parser {
	return @"∅";
}

-(id)nullParser:(HammerNullParser *)parser {
	return @"ε";
}


-(id)nullReductionParser:(HammerNullReductionParser *)parser {
	return [NSString stringWithFormat:@"ε↓{%@}", [parser.trees.allObjects componentsJoinedByString:@", "]];
}


-(id)termParser:(HammerTermParser *)parser {
	return [NSString stringWithFormat:@"'%@'", parser.term];
}


-(id)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [NSString stringWithFormat:@"{%@ | %@}", [self visit:left], [self visit:right]];
}

-(id)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [NSString stringWithFormat:@"(%@ %@)", [self visit:first], [self visit:second]];
}

-(id)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return [NSString stringWithFormat:@"%@ → %@", [self visit:child], @"ƒ"];
}

@end
