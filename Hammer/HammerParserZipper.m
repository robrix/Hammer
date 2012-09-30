//  HammerParserZipper.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerParserZipper.h"
#import <Hammer/Hammer.h>

@implementation HammerParserZipper

+(void)zip:(NSArray *)parsers block:(void(^)(NSArray *parsers, bool *stop))block {
	for (HammerParser *parser in parsers) {
		
	}
	bool shouldStop = NO;
	while (!shouldStop) {
		block(parsers, &shouldStop);
		shouldStop = YES;
	}
}

@end
