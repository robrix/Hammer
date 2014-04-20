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


#pragma mark NSObject

-(NSString *)description {
	return [NSString stringWithFormat:@"%@:%@", self.keyPath, self.combinator.name ?: self.combinator.description];
}

@end
