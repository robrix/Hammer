//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMRNull.h"
#import "HMROnce.h"

@interface HMRNull ()

@property (readonly) NSSet *forest;

@end

@implementation HMRNull

-(instancetype)initWithForest:(NSSet *)forest {
	NSParameterAssert(forest != nil);
	
	if ((self = [super init])) {
		_forest = [forest copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object {
	return HMRNone();
}


-(NSSet *)reduceParseForest {
	return self.forest;
}


-(NSString *)describe {
	__block NSString *separator = @"";
	NSString *forest = [self.forest red_reduce:[NSMutableString new] usingBlock:^(NSMutableString *into, id each) {
		[into appendString:separator];
		[into appendString:[each description]];
		separator = @", ";
		return into;
	}];
	return self.forest == nil?
		@"ε"
	:	[NSString stringWithFormat:@"ε↓{%@}", forest];
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
	return [[HMRNull alloc] initWithForest:forest];
}
