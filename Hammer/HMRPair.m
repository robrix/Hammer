//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMROnce.h"
#import "HMRPair.h"

@implementation HMRPair

+(instancetype)null {
	return HMROnce([[self alloc] initWithFirst:nil rest:nil]);
}

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


#pragma mark REDAppendable

-(instancetype)red_append:(id<REDReducible>)from {
	REDReducingBlock reverse = ^(HMRPair *(^into)(HMRPair *), id each) {
		return [^(HMRPair *x) { return into(HMRCons(each, x)); } copy];
	};
	HMRPair *(^terminate)(HMRPair *) = [from red_reduce:[self red_reduce:REDIdentityMapBlock usingBlock:reverse] usingBlock:reverse];
	return terminate(self.class.null);
}

l3_test(@selector(red_append:)) {
	HMRPair *appended = [HMRList(@1, @2, @3, nil) red_append:@[@4, @5]];
	l3_expect(appended).to.equal(HMRList(@1, @2, @3, @4, @5, nil));
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

-(NSUInteger)hash {
	return 0x3ff6a09e667f3bcdllu ^ [self.first hash] ^ [self.rest hash];
}

@end


HMRPair *HMRCons(id first, id rest) {
	return (first == nil && rest == nil)?
		[HMRPair null]
	:	[[HMRPair alloc] initWithFirst:first rest:rest];
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
