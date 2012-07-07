//  HammerList.h
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

id HammerArrayToList(NSArray *array, NSUInteger index, id(^nullary)(), id(^unary)(id), id(^binary)(id, id));
