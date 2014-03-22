//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMRNullReduction.h"

@implementation HMRNullReduction

+(instancetype)combinatorWithElement:(id<NSObject, NSCopying>)element {
	NSParameterAssert(element != nil);
	
	return [[self alloc] initWithParseForest:[NSSet setWithObject:element]];
}

-(instancetype)initWithParseForest:(NSSet *)parseForest {
	if ((self = [super init])) {
		_parseForest = [parseForest copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id<NSObject, NSCopying>)element {
	return [HMREmpty parser];
}


-(NSSet *)deforest {
	return self.parseForest;
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"ε ↓ %@", self.parseForest];
}

@end
