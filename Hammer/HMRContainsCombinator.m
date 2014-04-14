//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRContainsCombinator.h"
#import "HMROnce.h"

@interface HMRContainsCombinator ()

+(NSDictionary *)namesByCharacterSet;
+(NSDictionary *)characterSetsByName;

@end

@implementation HMRContainsCombinator

-(instancetype)initWithCharacterSet:(NSCharacterSet *)characterSet {
	NSParameterAssert(characterSet != nil);
	
	if ((self = [super init])) {
		_set = [characterSet copy];
	}
	return self;
}


#pragma mark HMRPredicateCombinator

-(bool)evaluateWithObject:(id)object {
	return [self.set hmr_containsObject:object];
}

l3_test(@selector(evaluateWithObject:)) {
	HMRContainsCombinator *combinator = [[HMRContainsCombinator alloc] initWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
	l3_expect([combinator evaluateWithObject:@"a"]).to.equal(@YES);
	l3_expect([combinator evaluateWithObject:@"1"]).to.equal(@YES);
}


#pragma mark HMRTerminal

-(NSString *)describe {
	return [NSString stringWithFormat:@"[%@]", self.class.namesByCharacterSet[self.set] ?: self.set];
}

l3_test(@selector(description)) {
	l3_expect(HMRContains([NSCharacterSet alphanumericCharacterSet]).description).to.equal(@"[[:alnum:]]");
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRContainsCombinator *)object {
	return
		[super isEqual:object]
	&&	[self.set isEqual:object.set];
}

-(NSUInteger)hash {
	return
		@"HMRContainsCombinator".hash
	^	self.set.hash;
}


#pragma mark Named sets

static NSString * const HMRAlphanumericCharacterSetName = @"[:alnum:]";
static NSString * const HMRAlphabeticCharacterSetName = @"[:alpha:]";
static NSString * const HMRWhitespaceCharacterSetName = @"[:blank:]";
static NSString * const HMRWhitespaceAndNewlineCharacterSetName = @"[:space:]";

+(NSDictionary *)characterSetsByName {
	return HMROnce(@{
		HMRAlphanumericCharacterSetName: [NSCharacterSet alphanumericCharacterSet],
		HMRAlphabeticCharacterSetName: [NSCharacterSet letterCharacterSet],
		HMRWhitespaceCharacterSetName: [NSCharacterSet whitespaceCharacterSet],
		HMRWhitespaceAndNewlineCharacterSetName: [NSCharacterSet whitespaceAndNewlineCharacterSet],
	});
}

+(NSDictionary *)namesByCharacterSet {
	return HMROnce([@{} red_append:REDMap(self.characterSetsByName, ^(NSString *key) {
		return @[ self.characterSetsByName[key], key ];
	})]);
}

l3_test(@selector(namesByCharacterSet)) {
	l3_expect(HMRContainsCombinator.namesByCharacterSet[HMRContainsCombinator.characterSetsByName[HMRAlphabeticCharacterSetName]]).to.equal(HMRAlphabeticCharacterSetName);
}

@end


id<HMRCombinator> HMRContains(NSCharacterSet *characterSet) {
	return [[HMRContainsCombinator alloc] initWithCharacterSet:characterSet];
}
