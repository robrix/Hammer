//  HammerReductionFunction.h
//  Created by Rob Rix on 2012-09-12.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

typedef id (^HammerReductionFunction)(id tree);

extern HammerReductionFunction HammerIdentityReductionFunction;
