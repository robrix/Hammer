//  HammerParserIsEqualPredicate.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerParserIsEqualPredicate.h"
#import "HammerLeastFixedPointVisitor.h"
#import <Hammer/Hammer.h>

@interface HammerParserIsEqualPredicate () <HammerVisitor>

@property (nonatomic, readonly) HammerParser *parser1;
@property (nonatomic, readonly) id parser2;

@end

@implementation HammerParserIsEqualPredicate

-(instancetype)initWithParser:(HammerParser *)parser1 parser:(HammerParser *)parser2 {
	if ((self = [super init])) {
		_parser1 = parser1;
		_parser2 = parser2;
	}
	return self;
}


+(bool)isParser:(HammerParser *)parser1 equalToParser:(HammerParser *)parser2 {
	return [[parser1 acceptVisitor:[[HammerLeastFixedPointVisitor alloc] initWithBottom:@NO visitor:[[self alloc] initWithParser:parser1 parser:parser2]]] boolValue];
}


-(NSNumber *)emptyParser:(HammerEmptyParser *)parser {
	return @(parser == self.parser2);
}

-(NSNumber *)nullParser:(HammerNullParser *)parser {
	return @(parser == self.parser2);
}

-(NSNumber *)nullReductionParser:(HammerNullReductionParser *)parser {
	HammerNullReductionParser *parser2 = self.parser2;
	return @(
		[parser2 isKindOfClass:[HammerNullReductionParser class]]
	&&	[parser2.trees isEqual:parser.trees]
	);
}


-(NSNumber *)termParser:(HammerTermParser *)parser {
	HammerTermParser *parser2 = self.parser2;
	return @(
		[parser2 isKindOfClass:[HammerTermParser class]]
	&&	[parser2.term isEqual:parser.term]
	);
}


-(NSNumber *)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	HammerAlternationParser *parser2 = self.parser2;
	return @NO;
	return @(
		[parser2 isKindOfClass:[HammerAlternationParser class]]
//	&&	[parser2.left ]
	);
}

@end
