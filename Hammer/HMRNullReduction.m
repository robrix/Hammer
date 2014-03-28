//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMRNullReduction.h"

@implementation HMRNullReduction

+(instancetype)combinatorWithElement:(id<NSObject, NSCopying>)element {
	NSParameterAssert(element != nil);
	
	return [[self alloc] initWithParseForest:[NSSet setWithObject:element]];
}

+(instancetype)combinatorWithParseForest:(NSSet *)parseForest {
	return [[self alloc] initWithParseForest:parseForest];
}

-(instancetype)initWithParseForest:(NSSet *)parseForest {
	NSParameterAssert(parseForest != nil);
	
	if ((self = [super init])) {
		_parseForest = [parseForest copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)element {
	return [HMREmpty parser];
}


-(NSSet *)reduceParseForest {
	return self.parseForest;
}

@synthesize parseForest = _parseForest;


-(NSString *)describe {
	return [NSString stringWithFormat:@"ε ↓ %@", self.parseForest];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRNullReduction *)object {
	return
		[object isKindOfClass:[HMRNullReduction class]]
	&&	[object.parseForest isEqual:self.parseForest];
}

@end
