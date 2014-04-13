//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRCase.h"
#import "HMRCombinator.h"
#import "HMROnce.h"
#import <Obstruct/apply.h>

@implementation HMRCase {
	REDPredicateBlock _predicate;
	id (^_block)();
}

+(instancetype)case:(REDPredicateBlock)predicate then:(id (^)())block {
	return [[self alloc] initWithPredicate:predicate thenBlock:block];
}

+(instancetype)caseWithPredicate:(id<HMRPredicate>)predicate block:(id (^)())block {
	return [[self alloc] initWithPredicate:^(id subject) {
		return [predicate matchObject:subject];
	} thenBlock:block];
}

-(instancetype)initWithPredicate:(REDPredicateBlock)predicate thenBlock:(id (^)())block {
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
	l3_expect(HMRMatch(object, @[ [HMRBind() then:REDIdentityMapBlock] ])).to.equal(object);
	l3_expect(HMRMatch(HMRConcatenate(HMRLiteral(@"x"), HMRLiteral(@"y")), @[ [HMRConcatenate(HMRAny(), HMRBind()) then:REDIdentityMapBlock] ])).to.equal(HMRLiteral(@"y"));
}


@interface HMRAnyCombinator : NSObject <HMRCombinator>
@end

@implementation HMRAnyCombinator

#pragma mark HMRCombinator

-(id<HMRCombinator>)derivative:(id<NSObject,NSCopying>)object {
	return HMRCaptureTree(object);
}


-(bool)isNullable {
	return NO;
}

-(bool)isCyclic {
	return NO;
}


-(NSSet *)parseForest {
	return [NSSet set];
}


-(id<HMRCombinator>)compaction {
	return self;
}


-(NSString *)description {
	return @"↓";
}


@synthesize name = _name;

-(instancetype)withName:(NSString *)name {
	if (!_name) _name = [name copy];
	return self;
}


#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	return YES;
}

-(id<HMRCase>)then:(id (^)())block {
	return [HMRCase caseWithPredicate:self block:block];
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return block(initial, self);
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}


#pragma mark NSObject

-(BOOL)isEqual:(id)object {
	return [self matchObject:object];
}

@end


@interface HMRBindCombinator : HMRAnyCombinator <HMRCombinator>
@end

@implementation HMRBindCombinator

#pragma mark HMRPredicate

-(bool)matchObject:(id)object {
	NSMutableArray *bindings = (__bridge NSMutableArray *)HMRBindings;
	[bindings addObject:object];
	return YES;
}

@end


id HMRBind(void) {
	return HMROnce([HMRBindCombinator new]);
}

id HMRAny(void) {
	return HMROnce([HMRAnyCombinator new]);
}
