//  HammerParserFormatter.m
//  Created by Rob Rix on 2012-08-19.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerConcatenationParser.h"
#import "HammerEmptyParser.h"
#import "HammerIdentitySymbolizer.h"
#import "HammerMemoizingVisitor.h"
#import "HammerNullParser.h"
#import "HammerNullReductionParser.h"
#import "HammerParserFormatter.h"
#import "HammerReductionParser.h"
#import "HammerTermParser.h"

@interface HammerParserFormatter () <HammerVisitor>
@end

@implementation HammerParserFormatter

+(instancetype)formatter {
	static HammerParserFormatter *formatter = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		formatter = [self new];
	});
	return formatter;
}

+(NSString *)format:(HammerParser *)parser {
	return [parser acceptVisitor:[[HammerMemoizingVisitor alloc] initWithVisitor:[self formatter] symbolizer:[HammerIdentitySymbolizer symbolizer]]];
}


-(NSString *)format:(HammerLazyVisitable)visitable {
	return [HammerForce(visitable) acceptVisitor:self];
}


-(NSString *)emptyParser:(HammerEmptyParser *)parser {
	return @"∅";
}

-(NSString *)nullParser:(HammerNullParser *)parser {
	return @"ε";
}


-(NSString *)nullReductionParser:(HammerNullReductionParser *)parser {
	return [NSString stringWithFormat:@"ε↓{%@}", [parser.trees.allObjects componentsJoinedByString:@", "]];
}


-(NSString *)termParser:(HammerTermParser *)parser {
	return [NSString stringWithFormat:@"'%@'", parser.term];
}


-(NSString *)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [NSString stringWithFormat:@"{%@ | %@}", [self format:left], [self format:right]];
}

-(NSString *)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [NSString stringWithFormat:@"(%@ %@)", [self format:first], [self format:second]];
}

-(NSString *)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return [NSString stringWithFormat:@"%@ → %@", [self format:child], @"ƒ"];
}

@end
