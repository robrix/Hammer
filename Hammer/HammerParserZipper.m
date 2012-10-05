//  HammerParserZipper.m
//  Created by Rob Rix on 2012-09-30.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerParserZipper.h"
#import "HammerParserEnumerator.h"
#import <Hammer/Hammer.h>

static NSArray *map(id<NSFastEnumeration> collection, id(^block)(id)) {
	NSMutableArray *mapped = [NSMutableArray new];
	for (id element in collection) {
		[mapped addObject:block(element) ?: [NSNull null]];
	}
	return mapped;
}

@implementation HammerParserZipper

+(void)zip:(NSArray *)parsers block:(void(^)(NSArray *parsers, bool *stop))block {
	NSArray *enumerators = map(parsers, ^(HammerParser *parser) {
		return [[HammerParserEnumerator alloc] initWithParser:parser];
	});
	bool shouldStop = NO;
	while (!shouldStop) {
		__block NSUInteger liveCount = 0;
		parsers = map(enumerators, ^(HammerParserEnumerator *enumerator) {
			id result = [enumerator nextObject];
			if (result)
				liveCount++;
			return result;
		});
		if (liveCount)
			block(parsers, &shouldStop);
		else
			break;
	}
}

@end
