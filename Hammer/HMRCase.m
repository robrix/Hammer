//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRCombinator.h"
#import <Obstruct/apply.h>

@implementation HMRCase {
	id<HMRPredicate> _predicate;
	id (^_block)();
}

+(instancetype)caseWithPredicate:(id<HMRPredicate>)predicate block:(id (^)())block {
	return [[self alloc] initWithPredicate:predicate block:block];
}

-(instancetype)initWithPredicate:(id<HMRPredicate>)predicate block:(id (^)())block {
	NSParameterAssert(block != nil);
	
	if ((self = [super init])) {
		_predicate = [predicate ?: HMRAny() copy];
		_block = [block copy];
	}
	return self;
}


static _Thread_local CFMutableArrayRef HMRBindings;
+(NSMutableArray *)bindings {
	return (__bridge NSMutableArray *)HMRBindings;
}

+(void)setBindings:(NSMutableArray *)bindings {
	HMRBindings = (CFMutableArrayRef)CFBridgingRetain(bindings);
}

-(id)evaluateWithObject:(id)object {
	NSMutableArray *previous = self.class.bindings;
	self.class.bindings = [NSMutableArray new];
	
	id result;
	
	if ([_predicate matchObject:object]) {
		result = obstr_block_apply_array(_block, self.class.bindings);
	}
	
	self.class.bindings = previous;
	
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
	l3_expect(HMRMatch(object, @[ [HMRCase caseWithPredicate:HMRAny() block:^{ return @YES; }] ])).to.equal(@YES);
	l3_expect(HMRMatch(object, @[ [HMRBind() then:REDIdentityMapBlock] ])).to.equal(object);
	l3_expect(HMRMatch(HMRAnd(HMREqual(@"x"), HMREqual(@"y")), @[ [HMRAnd(HMRAny(), HMRBind()) then:REDIdentityMapBlock] ])).to.equal(HMREqual(@"y"));
}
