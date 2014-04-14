//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCharacterSetCombinator.h"
#import "HMROnce.h"

@interface HMRCharacterSetCombinator ()

+(NSDictionary *)namesByCharacterSet;
+(NSDictionary *)characterSetsByName;

@end

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

l3_test(@selector(evaluateWithObject:)) {
	HMRCharacterSetCombinator *combinator = [[HMRCharacterSetCombinator alloc] initWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
	l3_expect([combinator evaluateWithObject:@"a"]).to.equal(@YES);
	l3_expect([combinator evaluateWithObject:@"1"]).to.equal(@YES);
}


#pragma mark HMRTerminal

-(NSString *)describe {
	return [NSString stringWithFormat:@"[%@]", self.class.namesByCharacterSet[self.characterSet] ?: self.characterSet];
}

l3_test(@selector(description)) {
	l3_expect(HMRCharacterSet([NSCharacterSet alphanumericCharacterSet]).description).to.equal(@"[[:alnum:]]");
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRCharacterSetCombinator *)object {
	return
		[super isEqual:object]
	&&	[self.characterSet isEqual:object.characterSet];
}

-(NSUInteger)hash {
	return
		@"HMRCharacterSetCombinator".hash
	^	self.characterSet.hash;
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
	l3_expect(HMRCharacterSetCombinator.namesByCharacterSet[HMRCharacterSetCombinator.characterSetsByName[HMRAlphabeticCharacterSetName]]).to.equal(HMRAlphabeticCharacterSetName);
}

@end


id<HMRCombinator> HMRCharacterSet(NSCharacterSet *characterSet) {
	return [[HMRCharacterSetCombinator alloc] initWithCharacterSet:characterSet];
}
