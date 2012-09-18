//  HammerEmptyParser.m
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEmptyParser.h"

@implementation HammerEmptyParser

+(instancetype)parser {
	static HammerEmptyParser *parser = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		parser = [self new];
	});
	return parser;
}


-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	return [visitor emptyParser:self];
}

@end
