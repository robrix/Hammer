//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRKeyValueCoding.h"
#import "HMRKVCCombinator.h"

@implementation HMRKVCCombinator

+(instancetype)keyPath:(NSString *)keyPath combinator:(HMRCombinator *)combinator {
	return [[self alloc] initWithKeyPath:keyPath combinator:combinator];
}

-(instancetype)initWithKeyPath:(NSString *)keyPath combinator:(HMRCombinator *)combinator {
	if ((self = [super init])) {
		_keyPath = [keyPath copy];
		_combinator = [combinator copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(HMRCombinator *)derivative:(id<NSObject,NSCopying,HMRKeyValueCoding>)object {
	return [self.combinator derivative:[object valueForKeyPath:self.keyPath]];
}


#pragma mark HMRPredicate

-(bool)matchObject:(id<HMRKeyValueCoding>)object {
	return
		[super matchObject:object]
	&&	[self.combinator matchObject:[object valueForKeyPath:self.keyPath]];
}

l3_test(@selector(matchObject:)) {
	NSString *string = @"description";
	HMRCombinator *description = [HMRKVCCombinator keyPath:@"description" combinator:[HMRCombinator literal:string]];
	l3_expect([description matchObject:string]).to.equal(@YES);
}


#pragma mark NSObject

-(NSString *)description {
	return [NSString stringWithFormat:@"%@:%@", self.keyPath, self.combinator.name ?: self.combinator.description];
}

@end
