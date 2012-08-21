//  HammerMemoization.h
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

#define HammerMemoizedValue(value, initializer) value ?: (value = (initializer))
