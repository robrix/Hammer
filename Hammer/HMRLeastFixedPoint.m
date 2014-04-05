//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLeastFixedPoint.h"

id HMRLeastFixedPoint(id least, id(^block)(id)) {
	bool changed = false;
	do {
		id next = block(least);
		changed = !((least == next) || [least isEqual:next]);
		least = next;
	} while (changed);
	return least;
}

l3_addTestSubjectTypeWithFunction(HMRLeastFixedPoint);
l3_test(&HMRLeastFixedPoint) {
	id lfp = HMRLeastFixedPoint(@-0.9, ^(NSNumber *x) {
		return @(x.doubleValue * x.doubleValue);
	});
	l3_expect(lfp).to.equal(@0);
}
