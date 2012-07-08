//  HammerRepetitionPattern.m
//  Created by Rob Rix on 12-06-27.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEpsilonPattern.h"
#import "HammerConcatenationPattern.h"
#import "HammerDerivativePattern.h"
#import "HammerRepetitionPattern.h"

@interface HammerRepetitionPattern () <HammerVisitable>
@end

@implementation HammerRepetitionPattern {
	id<HammerDerivativePattern> _pattern;
	HammerLazyPattern _lazyPattern;
}

+(id<HammerPattern>)patternWithPattern:(HammerLazyPattern)pattern {
	HammerRepetitionPattern *instance = [self new];
	instance->_lazyPattern = pattern;
	return instance;
}


-(id<HammerDerivativePattern>)pattern {
	return _pattern ?: (_pattern = HammerDerivativePattern(_lazyPattern()));
}


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	return [HammerConcatenationPattern patternWithLeftPattern:HammerDelayPattern([self.pattern derivativeWithRespectTo:object]) rightPattern:HammerDelayPattern(self)];
}


-(BOOL)isNullable {
	return YES;
}


-(BOOL)isEpsilon {
	return self.pattern.isNull || self.pattern.isEpsilon;
}


-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	id childResult = nil;
	if ([visitor visitObject:self])  {
		childResult = [self.pattern acceptVisitor:visitor];
	}
	return [visitor leaveObject:self withVisitedChildren:childResult];
}


-(BOOL)isEqualToRepetitionPattern:(HammerRepetitionPattern *)other {
	return
		[other isKindOfClass:self.class]
	&&	[self.pattern isEqual:other.pattern];
}

-(BOOL)isEqual:(id)object {
	return [self isEqualToRepetitionPattern:object];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
