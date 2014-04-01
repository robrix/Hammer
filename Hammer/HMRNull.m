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
		description = [tree description];
	else if ([tree isKindOfClass:[NSString class]])
		description = [self quoteString:tree];
	return description;
}


-(NSString *)describe {
	NSString *forest = [@"" red_append:REDJoin(REDMap(self.forest, ^(id each) {
		return [self describeParseTree:each];
	}), @", ")];
	return self.forest == nil?
		@"ε"
	:	[NSString stringWithFormat:@"ε↓{%@}", forest];
}

l3_test(@selector(description)) {
	l3_expect(HMRCaptureTree(singleQuote).description).to.equal(@"ε↓{\"'\"}");
	l3_expect(HMRCaptureTree(doubleQuote).description).to.equal(@"ε↓{'\"'}");
	NSString *singleAndDoubleQuotes = [singleQuote stringByAppendingString:doubleQuote];
	l3_expect(HMRCaptureTree(singleAndDoubleQuotes).description).to.equal(@"ε↓{'\\'\"'}");
	
	l3_expect(HMRCaptureTree(@[ singleQuote, doubleQuote, singleAndDoubleQuotes]).description).to.equal(@"ε↓{(\"'\", '\"', '\\'\"')}");
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
