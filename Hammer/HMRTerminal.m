//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRTerminal.h"

@implementation HMRTerminal

#pragma mark HMRCombinator

-(id<HMRCombinator>)derivative:(id<NSObject,NSCopying>)object {
	return self;
}


-(NSSet *)parseForest {
	return [NSSet set];
}


-(instancetype)compaction {
	return self;
}


-(NSString *)describe {
	return super.description;
}

-(NSString *)description {
	return self.name?
		[NSString stringWithFormat:@"%@ -> %@", self.name, [self describe]]
	:	[self describe];
}


@dynamic hash;

@end
