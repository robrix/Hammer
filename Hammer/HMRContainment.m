//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRContainment.h"
#import "HMROnce.h"

@interface HMRContainment ()

+(NSDictionary *)namesByCharacterSet;
+(NSDictionary *)characterSetsByName;

@end

@implementation HMRContainment

+(instancetype)containedIn:(id<HMRSet>)set {
	return [[HMRContainment alloc] initWithSet:set];
}

-(instancetype)initWithSet:(id<HMRSet>)set {
	NSParameterAssert(set != nil);
	
	if ((self = [super init])) {
		_set = [set copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRPredicateCombinator

-(bool)evaluateWithObject:(id)object {
	return [self.set hmr_containsObject:object];
}

l3_test(@selector(evaluateWithObject:)) {
	HMRContainment *combinator = [[HMRContainment alloc] initWithSet:[NSCharacterSet alphanumericCharacterSet]];
	l3_expect([combinator evaluateWithObject:@"a"]).to.equal(@YES);
	l3_expect([combinator evaluateWithObject:@"1"]).to.equal(@YES);
}


#pragma mark HMRTerminal

-(NSString *)describe {
	return [NSString stringWithFormat:@"[%@]", self.class.namesByCharacterSet[self.set] ?: self.set];
}

l3_test(@selector(description)) {
	l3_expect([HMRCombinator containedIn:[NSCharacterSet alphanumericCharacterSet]].description).to.equal(@"[[:alnum:]]");
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRContainment *)object {
	return
		[super isEqual:object]
	&&	[self.set isEqual:object.set];
}

-(NSUInteger)hash {
	return
		@"HMRContainment".hash
	^	self.set.hash;
}


#pragma mark Named sets

static NSString * const HMRAlphanumericCharacterSetName = @"[:alnum:]";
static NSString * const HMRAlphabeticCharacterSetName = @"[:alpha:]";
static NSString * const HMRASCIICharacterSetName = @"[:ascii:]";
static NSString * const HMRWhitespaceCharacterSetName = @"[:blank:]";
static NSString * const HMRControlCharacterSetName = @"[:cntrl:]";
static NSString * const HMRDecimalDigitCharacterSetName = @"[:digit:]";
static NSString * const HMRWhitespaceAndNewlineCharacterSetName = @"[:space:]";

+(NSDictionary *)characterSetsByName {
	return HMROnce(@{
		HMRAlphanumericCharacterSetName: [NSCharacterSet alphanumericCharacterSet],
		HMRAlphabeticCharacterSetName: [NSCharacterSet letterCharacterSet],
		HMRASCIICharacterSetName: [NSCharacterSet characterSetWithRange:(NSRange){ .length = 128 }],
		HMRWhitespaceCharacterSetName: [NSCharacterSet whitespaceCharacterSet],
		HMRControlCharacterSetName: [NSCharacterSet controlCharacterSet],
		HMRDecimalDigitCharacterSetName: [NSCharacterSet decimalDigitCharacterSet],
		HMRWhitespaceAndNewlineCharacterSetName: [NSCharacterSet whitespaceAndNewlineCharacterSet],
	});
}

+(NSDictionary *)namesByCharacterSet {
	return HMROnce([@{} red_append:REDMap(self.characterSetsByName, ^(NSString *key) {
		return @[ self.characterSetsByName[key], key ];
	})]);
}

l3_test(@selector(namesByCharacterSet)) {
	l3_expect(HMRContainment.namesByCharacterSet[HMRContainment.characterSetsByName[HMRAlphabeticCharacterSetName]]).to.equal(HMRAlphabeticCharacterSetName);
}

@end
