//  HammerLaziness.h
//  Created by Rob Rix on 2012-09-10.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

@class HammerParser;

typedef HammerParser *(^HammerLazyParser)();
#define HammerDelay(p) ^{ return (p); }
#define HammerForce(l) ((l)())
