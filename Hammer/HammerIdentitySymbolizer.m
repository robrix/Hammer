//  HammerIdentitySymbolizer.m
//  Created by Rob Rix on 2012-07-09.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerIdentitySymbolizer.h"

@implementation HammerIdentitySymbolizer

+(instancetype)symbolizer {
	static HammerIdentitySymbolizer *symbolizer = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		symbolizer = [self new];
	});
	return symbolizer;
}


-(id)symbolForObject:(id)object {
	return object;
}

@end
