//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRCombinator.h"
#import <Obstruct/apply.h>

@implementation HMRCase {
	REDPredicateBlock _predicate;
	id (^_block)();
}

+(id)match:(id)object withCases:(NSArray *)cases {
	id result;
	
	for (HMRCase *each in cases) {
		result = [each evaluateWithObject:object];
		
		if (result != nil) break;
	}
	
	return result;
}

l3_test(@selector(match:withCases:)) {
	id object = [NSObject new];
	l3_expect([HMRCase match:object withCases:@[ [HMRCase case:REDTruePredicateBlock then:^{ return @YES; }] ]]).to.equal(@YES);
	l3_expect([HMRCase match:object withCases:@[ [HMRCase case:HMRBind then:REDIdentityMapBlock] ]]).to.equal(object);
	l3_expect([HMRCase match:HMRConcatenate(HMRLiteral(@"x"), HMRLiteral(@"y")) withCases:@[ [HMRCase case:HMRConcatenationPredicate(nil, HMRBind) then:REDIdentityMapBlock] ]]).to.equal(HMRLiteral(@"y"));
}


+(instancetype)case:(REDPredicateBlock)predicate then:(id(^)())block {
	return [[self alloc] initWithPredicate:predicate thenBlock:block];
}

-(instancetype)initWithPredicate:(REDPredicateBlock)predicate thenBlock:(id(^)())block {
	NSParameterAssert(block != nil);
	
	if ((self = [super init])) {
		_predicate = [predicate ?: REDTruePredicateBlock copy];
		_block = [block copy];
	}
	return self;
}


static _Thread_local CFMutableArrayRef variables;

-(id)evaluateWithObject:(id)object {
	CFMutableArrayRef previous = variables;
	NSMutableArray *bindings = [NSMutableArray new];
	variables = (__bridge CFMutableArrayRef)bindings;
	
	id result;
	
	if (_predicate(object)) {
		result = obstr_block_apply_array(_block, bindings);
	}
	
	variables = previous;
	
	return result;
}

@end


id HMRMatch(id subject, NSArray *cases) {
	id result;
	for (HMRCase *each in cases) {
		if ((result = [each evaluateWithObject:subject])) break;
	}
	return result;
}

l3_addTestSubjectTypeWithFunction(HMRMatch)
l3_test(&HMRMatch) {
	id object = [NSObject new];
	l3_expect(HMRMatch(object, @[ [HMRCase case:REDTruePredicateBlock then:^{ return @YES; }] ])).to.equal(@YES);
	l3_expect(HMRMatch(object, @[ [HMRCase case:HMRBind then:REDIdentityMapBlock] ])).to.equal(object);
	l3_expect(HMRMatch(HMRConcatenate(HMRLiteral(@"x"), HMRLiteral(@"y")), @[ [HMRCase case:HMRConcatenationPredicate(nil, HMRBind) then:REDIdentityMapBlock] ])).to.equal(HMRLiteral(@"y"));
}


REDPredicateBlock const HMRBind = ^bool (id object) {
	NSMutableArray *bindings = (__bridge NSMutableArray *)variables;
	[bindings addObject:object];
	return YES;
};
