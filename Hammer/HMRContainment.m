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
	NSString *name = self.class.namesByCharacterSet[self.set];
	return name?
		[NSString stringWithFormat:@"[[:%@:]]", name]
	:	[NSString stringWithFormat:@"[%@]", self.set];
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

NSString * const HMRAlphanumericCharacterSetName = @"alnum";
NSString * const HMRAlphabeticCharacterSetName = @"alpha";
NSString * const HMRASCIICharacterSetName = @"ascii";
NSString * const HMRWhitespaceCharacterSetName = @"blank";
NSString * const HMRControlCharacterSetName = @"cntrl";
NSString * const HMRDecimalDigitCharacterSetName = @"digit";
//static NSString * const HMRGraphemeCharacterSetName = @"graph";
NSString * const HMRLowercaseLetterCharacterSetName = @"lower";
//static NSString * const HMRPrintableCharacterSetName = @"print";
NSString * const HMRPunctuationCharacterSetName = @"punct";
NSString * const HMRWhitespaceAndNewlineCharacterSetName = @"space";
NSString * const HMRUppercaseLetterCharacterSetName = @"upper";
//static NSString * const HMRWordCharacterSetName = @"word";
NSString * const HMRHexadecimalDigitCharacterSetName = @"xdigit";

+(NSDictionary *)characterSetsByName {
	return HMROnce(@{
		HMRAlphanumericCharacterSetName: [NSCharacterSet alphanumericCharacterSet],
		HMRAlphabeticCharacterSetName: [NSCharacterSet letterCharacterSet],
		HMRASCIICharacterSetName: [NSCharacterSet characterSetWithRange:(NSRange){ .length = 128 }],
		HMRWhitespaceCharacterSetName: [NSCharacterSet whitespaceCharacterSet],
		HMRControlCharacterSetName: [NSCharacterSet controlCharacterSet],
		HMRDecimalDigitCharacterSetName: [NSCharacterSet decimalDigitCharacterSet],
//		HMRGraphemeCharacterSetName: [NSCharacterSet ],
		HMRLowercaseLetterCharacterSetName: [NSCharacterSet lowercaseLetterCharacterSet],
//		HMRPrintableCharacterSetName: [NSCharacterSet ],
		HMRPunctuationCharacterSetName: [NSCharacterSet punctuationCharacterSet],
		HMRWhitespaceAndNewlineCharacterSetName: [NSCharacterSet whitespaceAndNewlineCharacterSet],
		HMRUppercaseLetterCharacterSetName: [NSCharacterSet uppercaseLetterCharacterSet],
//		HMRWordCharacterSetName: [NSCharacterSet ],
		HMRHexadecimalDigitCharacterSetName: [NSCharacterSet characterSetWithCharactersInString:@"abcdefABCDEF0123456789"],
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
