//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRCombinator.h"
#import <Obstruct/apply.h>

@implementation HMRCase {
	REDPredicateBlock _predicate;
	id (^_block)();
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


static _Thread_local CFMutableArrayRef HMRBindings;

-(id)evaluateWithObject:(id)object {
	CFMutableArrayRef previous = HMRBindings;
	HMRBindings = (CFMutableArrayRef)CFBridgingRetain([NSMutableArray new]);
	
	id result;
	
	if (_predicate(object)) {
		result = obstr_block_apply_array(_block, (__bridge NSMutableArray *)HMRBindings);
	}
	
	HMRBindings = previous;
	
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
	NSMutableArray *bindings = (__bridge NSMutableArray *)HMRBindings;
	[bindings addObject:object];
	return YES;
};
