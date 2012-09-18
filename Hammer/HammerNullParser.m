//  HammerNullParser.m
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerNullParser.h"

@implementation HammerNullParser

+(instancetype)parser {
	static HammerNullParser *parser = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		parser = [self new];
	});
	return parser;
}


-(BOOL)canParseNull {
	return YES;
}


-(id)acceptVisitor:(id<HammerVisitor>)algebra {
	return [algebra nullParser];
}

@end
