//  HammerDerivativePattern.m
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEpsilonPattern.h"
#import "HammerDerivativePattern.h"
#import "HammerNullPattern.h"
#import "HammerRepetitionPattern.h"

@interface HammerDerivativePatternDecorator : NSObject <HammerDerivativePattern>

+(id<HammerDerivativePattern>)derivativePatternWithPattern:(id<HammerPattern>)pattern;

@property (nonatomic, readonly) id<HammerPattern> pattern;

@end

@implementation HammerDerivativePatternDecorator {
	id<HammerPattern> _pattern;
}

+(id<HammerDerivativePattern>)derivativePatternWithPattern:(id<HammerPattern>)pattern {
	HammerDerivativePatternDecorator *decorator = [self new];
	decorator->_pattern = pattern;
	return decorator;
}


@synthesize pattern = _pattern;


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return [_pattern derivativeWithRespectTo:object];
}


-(BOOL)isNullable {
	BOOL isNullable = NO;
	if ([_pattern respondsToSelector:@selector(isNullable)])
		isNullable = ((id<HammerDerivativePattern>)_pattern).isNullable;
	return isNullable;
}


-(BOOL)isNull {
	return [_pattern respondsToSelector:@selector(isNull)] && ((id<HammerDerivativePattern>)_pattern).isNull;
}

-(BOOL)isEpsilon {
	return [_pattern respondsToSelector:@selector(isEpsilon)] && ((id<HammerDerivativePattern>)_pattern).isEpsilon;
}


-(BOOL)isEqual:(id)object {
	return
		[object isKindOfClass:self.class]
	&&	[self.pattern isEqual:[object pattern]];
}

-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end


id<HammerDerivativePattern> HammerDerivativePattern(id<HammerPattern> pattern) {
	return [pattern conformsToProtocol:@protocol(HammerDerivativePattern)]?
	(id<HammerDerivativePattern>)pattern
	:	[HammerDerivativePatternDecorator derivativePatternWithPattern:pattern];
}
