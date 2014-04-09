//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRPair.h"

@implementation HMRPair

-(instancetype)initWithFirst:(id)first rest:(id)rest {
	if ((self = [super init])) {
		_first = first;
		_rest = rest;
	}
	return self;
}


-(bool)isListNode {
	return
		self.isNil
	||	[self.rest isKindOfClass:[HMRPair class]];
}

-(bool)isNil {
	return self.first == nil && self.rest == nil;
}


#pragma mark REDReducible

-(id)red_reduce:(id)initial usingBlock:(REDReducingBlock)block {
	return self.isNil?
		initial
	:	[self.rest red_reduce:block(initial, self.first) usingBlock:block];
}

l3_test(@selector(red_reduce:usingBlock:)) {
	HMRPair *list = HMRList(@5, @1, @3, nil);
	l3_expect([@[] red_append:list]).to.equal(@[@5, @1, @3]);
}


#pragma mark NSCopying

-(instancetype)copyWithZone:(NSZone *)zone {
	return self;
}


#pragma mark NSObject

-(NSString *)descriptionForTree {
	return [NSString stringWithFormat:@"%@ . %@", self.first, self.rest];
}

-(NSString *)descriptionForList {
	return [self.rest isNil]?
		[NSString stringWithFormat:@"%@", self.first]
	:	[NSString stringWithFormat:@"%@ %@", self.first, [self.rest recursiveDescription]];
}

-(NSString *)recursiveDescription {
	return self.isListNode?
		self.descriptionForList
	:	self.descriptionForTree;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"(%@)", self.recursiveDescription];
}


-(BOOL)isEqual:(HMRPair *)pair {
	return
		[pair isKindOfClass:self.class]
	&&	((self.first == pair.first) || [self.first isEqual:pair.first])
	&&	((self.rest == pair.rest) || [self.rest isEqual:pair.rest]);
}

@end


HMRPair *HMRCons(id first, id rest) {
	return [[HMRPair alloc] initWithFirst:first rest:rest];
}

HMRPair *(^HMRPairVariadics)(va_list) = ^(va_list args) {
	id each = va_arg(args, id);
	return each?
		HMRCons(each, HMRPairVariadics(args))
	:	HMRCons(nil, nil);
};

HMRPair *HMRList(id first, ...) {
	va_list args;
	va_start(args, first);
	
	HMRPair *list = HMRCons(first, HMRPairVariadics(args));
	
	va_end(args);
	
	return list;
}

l3_addTestSubjectTypeWithFunction(HMRList)
l3_test(&HMRList) {
	HMRPair *list = HMRList(@"a", @"b", @"c", @"d", @"e", nil);
	l3_expect(list.first).to.equal(@"a");
	l3_expect(list.description).to.equal(@"(a b c d e)");
}