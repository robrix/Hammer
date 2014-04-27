//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRPredicateCombinator.h"
#import "HMRSet.h"

@interface HMRContainment : HMRPredicateCombinator

+(instancetype)containedIn:(id<HMRSet>)set;

@property (readonly) id<HMRSet> set;


/// A dictionary of named character sets keyed by their names.
+(NSDictionary *)characterSetsByName;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end

/// The name of the alphanumeric character set.
extern NSString * const HMRAlphanumericCharacterSetName;

/// The name of the alphabetic character set.
extern NSString * const HMRAlphabeticCharacterSetName;

/// The name of the ASCII character set.
extern NSString * const HMRASCIICharacterSetName;

/// The name of the whitespace character set.
extern NSString * const HMRWhitespaceCharacterSetName;

/// The name of the control character character set.
extern NSString * const HMRControlCharacterSetName;

/// The name of the decimal digit character set.
extern NSString * const HMRDecimalDigitCharacterSetName;

/// The name of the lowercase letter character set.
extern NSString * const HMRLowercaseLetterCharacterSetName;

/// The name of the punctuation character set.
extern NSString * const HMRPunctuationCharacterSetName;

/// The name of the whitespace and newline character set.
extern NSString * const HMRWhitespaceAndNewlineCharacterSetName;

/// The name of the uppercase letter character set.
extern NSString * const HMRUppercaseLetterCharacterSetName;

/// The name of the hexadecimal digit character set.
extern NSString * const HMRHexadecimalDigitCharacterSetName;
