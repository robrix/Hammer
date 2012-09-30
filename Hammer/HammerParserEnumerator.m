//  HammerParserEnumerator.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerParserEnumerator.h"
#import <Hammer/Hammer.h>

@interface HammerParserEnumerator () <HammerVisitor>

@property (nonatomic) HammerParser *parser;

@property (nonatomic, strong) HammerParserEnumerator *leftBranch;
@property (nonatomic, strong) HammerParserEnumerator *rightBranch;

@end

@implementation HammerParserEnumerator

-(instancetype)initWithParser:(HammerParser *)parser {
	if ((self = [super init])) {
		self.parser = [parser acceptVisitor:self];
	}
	return self;
}


-(HammerParser *)nextObject {
	HammerParser *currentParser = self.parser ?: [self.leftBranch nextObject] ?: [self.rightBranch nextObject];
	self.parser = nil;
	return currentParser;
}


-(HammerParserEnumerator *)branch:(HammerLazyVisitable)child {
	return [[HammerParserEnumerator alloc] initWithParser:(HammerParser *)child()];
}


-(HammerParser *)emptyParser:(HammerEmptyParser *)parser {
	return parser;
}

-(HammerParser *)nullParser:(HammerNullParser *)parser {
	return parser;
}

-(HammerParser *)nullReductionParser:(HammerNullReductionParser *)parser {
	return parser;
}


-(HammerParser *)termParser:(HammerTermParser *)parser {
	return parser;
}


-(HammerParser *)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	self.leftBranch = [self branch:left];
	self.rightBranch = [self branch:right];
	return parser;
}

-(HammerParser *)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	self.leftBranch = [self branch:first];
	self.rightBranch = [self branch:second];
	return parser;
}

-(HammerParser *)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	self.leftBranch = [self branch:child];
	return parser;
}

@end
