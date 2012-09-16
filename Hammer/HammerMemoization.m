//  HammerMemoization.m
//  Created by Rob Rix on 2012-09-15.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerMemoization.h"

HammerLazyParser HammerMemoizingLazyParser(HammerParser * __strong *variable, HammerLazyParser parser) {
	return ^{
		return HammerMemoizedValue(*variable, HammerForce(parser));
	};
}