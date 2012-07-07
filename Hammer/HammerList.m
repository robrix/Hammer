//  HammerList.m
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerList.h"

id HammerArrayToList(NSArray *array, NSUInteger index, id(^nullary)(), id(^unary)(id), id(^binary)(id, id)) {
	NSUInteger remainingCount = array.count - index;
	id list = nil;
	if (remainingCount == 0)
		list = nullary();
	else if (remainingCount == 1)
		list = unary(array.lastObject);
	else
		list = binary([array objectAtIndex:index], HammerArrayToList(array, index + 1, nullary, unary, binary));
	return list;
}
