//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCharacterSetCombinator.h"

@implementation HMRCharacterSetCombinator

-(instancetype)initWithCharacterSet:(NSCharacterSet *)characterSet {
	NSParameterAssert(characterSet != nil);
	
	if ((self = [super init])) {
		_characterSet = [characterSet copy];
	}
	return self;
}


#pragma mark HMRPredicateCombinator

-(bool)evaluateWithObject:(NSString *)string {
	return
		[string isKindOfClass:[NSString class]]
	&&	[[string stringByTrimmingCharactersInSet:self.characterSet] isEqual:@""];
}


#pragma mark HMRCombinator

-(NSString *)describe {
	return [NSString stringWithFormat:@"[%@]", self.characterSet];
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRCharacterSetCombinator *)object {
	return
		[super isEqual:object]
	&&	[object.characterSet isEqual:self.characterSet];
}

@end


id<HMRCombinator> HMRCharacterSet(NSCharacterSet *characterSet) {
	return [[HMRCharacterSetCombinator alloc] initWithCharacterSet:characterSet];
}
