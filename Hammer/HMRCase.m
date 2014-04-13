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
	variables = (CFMutableArrayRef)CFBridgingRetain(bindings);
	
	id result;
	
	if (_predicate(object)) {
		result = obstruct_apply_array(_block, bindings);
	}
	
	variables = previous;
	
	return result;
}

@end


REDPredicateBlock const HMRBind = ^bool (id object) {
	[(NSMutableArray *)CFBridgingRelease(variables) addObject:object];
	return YES;
};
