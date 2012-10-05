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

@implementation HammerParserEnumerator {
	NSMutableSet *_visitedParsers;
}

-(instancetype)initWithParser:(HammerParser *)parser visitedParsers:(NSMutableSet *)visitedParsers {
	if ((self = [super init])) {
		_visitedParsers = visitedParsers;
		self.parser = [parser acceptVisitor:self];
	}
	return self;
}

-(instancetype)initWithParser:(HammerParser *)parser {
	return [self initWithParser:parser visitedParsers:[NSMutableSet new]];
}


-(HammerParser *)nextObject {
	HammerParser *currentParser = self.parser ?: [self.leftBranch nextObject] ?: [self.rightBranch nextObject];
	self.parser = nil;
	return currentParser;
}


-(HammerParserEnumerator *)branch:(HammerLazyVisitable)child {
	return [[HammerParserEnumerator alloc] initWithParser:(HammerParser *)child() visitedParsers:_visitedParsers];
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
	return [self visitParser:parser block:^{
		self.leftBranch = [self branch:left];
		self.rightBranch = [self branch:right];
	}];
}

-(HammerParser *)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [self visitParser:parser block:^{
		self.leftBranch = [self branch:first];
		self.rightBranch = [self branch:second];
	}];
}

-(HammerParser *)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return [self visitParser:parser block:^{
		self.leftBranch = [self branch:child];
	}];
}


-(id)tokenForParser:(HammerParser *)parser {
	return [NSValue valueWithNonretainedObject:parser];
}

-(bool)hasVisitedParser:(HammerParser *)parser {
	return [_visitedParsers containsObject:[self tokenForParser:parser]];
}

-(HammerParser *)visitParser:(HammerParser *)parser block:(void(^)())block {
	if (![self hasVisitedParser:parser]) {
		[_visitedParsers addObject:[self tokenForParser:parser]];
		block();
		return parser;
	} else {
		return nil;
	}
}

@end
