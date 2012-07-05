//  HammerReferencePattern.m
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerReferencePattern.h"

@implementation HammerReferencePattern {
	id<HammerPattern> _pattern;
	HammerLazyPattern _lazy;
}

+(instancetype)patternWithPattern:(id<HammerPattern>)pattern {
	HammerReferencePattern *instance = [self new];
	instance->_pattern = pattern;
	return instance;
}

+(instancetype)patternWithLazyPattern:(HammerLazyPattern)lazy {
	HammerReferencePattern *instance = [self new];
	instance->_lazy = lazy;
	return instance;
}


-(id<HammerPattern>)lazyPattern {
	id<HammerPattern> pattern = _lazy();
	_lazy = nil;
	return pattern;
}

-(id<HammerPattern>)pattern {
	return _pattern ?: (_pattern = self.lazyPattern);
}


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return [self.pattern derivativeWithRespectTo:object];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
