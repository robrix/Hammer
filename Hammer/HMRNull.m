//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMRNull.h"
#import "HMROnce.h"

@interface HMRNull ()

+(instancetype)nullWithForest:(NSSet *)forest;

@property (readonly) NSSet *forest;

@end

@implementation HMRNull

+(instancetype)nullWithForest:(NSSet *)forest {
	return [[self alloc] initWithForest:forest];
}

-(instancetype)initWithForest:(NSSet *)forest {
	NSParameterAssert(forest != nil);
	
	if ((self = [super init])) {
		_forest = [forest copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return [HMREmpty empty];
}


-(NSSet *)reduceParseForest {
	return self.forest;
}


-(NSString *)describe {
	return self.forest == nil?
		@"ε"
	:	[NSString stringWithFormat:@"ε ↓ %@", self.forest];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRNull *)object {
	return
		[object isKindOfClass:[self class]]
	&&	[object.forest isEqual:self.forest];
}

@end


id<HMRCombinator> HMRCaptureTree(id object) {
	NSCParameterAssert(object != nil);
	
	return HMRCaptureForest([NSSet setWithObject:object]);
}

id<HMRCombinator> HMRCaptureForest(NSSet *forest) {
	return [HMRNull nullWithForest:forest];
}
