//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMRNull.h"
#import "HMROnce.h"

@implementation HMRNull

+(instancetype)captureForest:(NSSet *)parseForest {
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

-(HMRCombinator *)derivative:(id<NSObject, NSCopying>)object {
	return [HMRCombinator empty];
}


@synthesize parseForest = _parseForest;


-(NSString *)escapeBackslashesInString:(NSString *)string {
	return [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
}

-(NSString *)escapeString:(NSString *)marker inString:(NSString *)string {
	return [[self escapeBackslashesInString:string] stringByReplacingOccurrencesOfString:marker withString:[@"\\" stringByAppendingString:marker]];
}

-(NSString *)wrapString:(NSString *)string withPrefix:(NSString *)prefix suffix:(NSString *)suffix {
	return [[prefix stringByAppendingString:string] stringByAppendingString:suffix];
}

static NSString * const singleQuote = @"'";
static NSString * const doubleQuote = @"\"";
-(NSString *)quoteString:(NSString *)string {
	if ([string rangeOfString:singleQuote].length == 0) {
		string = [self wrapString:[self escapeBackslashesInString:string] withPrefix:singleQuote suffix:singleQuote];
	} else if ([string rangeOfString:doubleQuote].length == 0) {
		string = [self wrapString:[self escapeBackslashesInString:string] withPrefix:doubleQuote suffix:doubleQuote];
	} else {
		string = [self wrapString:[self escapeString:singleQuote inString:string] withPrefix:singleQuote suffix:singleQuote];
	}
	return string;
}

-(NSString *)describeParseTree:(id)tree {
	NSString *description;
	if ([tree isKindOfClass:[NSArray class]])
		description = [self wrapString:[self describeParseForest:tree] withPrefix:@"(" suffix:@")"];
	else if ([tree isKindOfClass:[NSString class]])
		description = [self quoteString:tree];
	else
		description = [tree description];
	return description;
}

-(NSString *)describeParseForest:(id<REDReducible>)parseForest {
	return [@"" red_append:REDJoin(REDMap(parseForest, ^(id each) {
		return [self describeParseTree:each];
	}), @", ")];
}


-(NSString *)describe {
	return self.parseForest == nil?
		@"ε"
	:	[NSString stringWithFormat:@"ε↓{%@}", [self describeParseForest:self.parseForest]];
}

l3_test(@selector(description)) {
	l3_expect([HMRCombinator captureTree:singleQuote].description).to.equal(@"ε↓{\"'\"}");
	l3_expect([HMRCombinator captureTree:doubleQuote].description).to.equal(@"ε↓{'\"'}");
	NSString *singleAndDoubleQuotes = [singleQuote stringByAppendingString:doubleQuote];
	l3_expect([HMRCombinator captureTree:singleAndDoubleQuotes].description).to.equal(@"ε↓{'\\'\"'}");
	
	l3_expect([HMRCombinator captureTree:@[ singleQuote, doubleQuote, singleAndDoubleQuotes ]].description).to.equal(@"ε↓{(\"'\", '\"', '\\'\"')}");
}


#pragma mark NSObject

-(BOOL)isEqual:(HMRNull *)object {
	return
		[object isKindOfClass:self.class]
	&&	[self.parseForest isEqual:object.parseForest];
}

-(NSUInteger)hash {
	return
		@"HMRNull".hash
	^	self.parseForest.hash;
}

@end
