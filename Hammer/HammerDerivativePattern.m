//  HammerDerivativePattern.m
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerChangeCell.h"
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
	NSMutableDictionary *_memoizedDerivationsByTerm;
	BOOL _hasMemoizedRecursiveAttributes;
	BOOL _isNullable;
	BOOL _isNull;
//	BOOL _isEpsilon;
}

+(id<HammerDerivativePattern>)derivativePatternWithPattern:(id<HammerPattern>)pattern {
	HammerDerivativePatternDecorator *decorator = [self new];
	decorator->_pattern = pattern;
	decorator->_memoizedDerivationsByTerm = [NSMutableDictionary new];
	return decorator;
}


@synthesize pattern = _pattern;


-(id<HammerPattern>)derivativeWithRespectTo:(id)object {
	id<HammerPattern> derivative = [_memoizedDerivationsByTerm objectForKey:object];
	if (!derivative) {
		derivative = [_pattern derivativeWithRespectTo:object];
		[_memoizedDerivationsByTerm setObject:derivative forKey:object];
	}
	return derivative;
}

-(void)memoizeRecursiveAttributes {
	if (!_hasMemoizedRecursiveAttributes) {
		_hasMemoizedRecursiveAttributes = YES;
		
		HammerChangeCell *change = nil;
		do {
			change = [HammerChangeCell new];
			
			[self updateRecursiveAttributes:change];
		} while(change.changed);
	}
}

-(void)updateRecursiveAttributes:(HammerChangeCell *)change {
	if (![change.visitedPatterns containsObject:self]) {
		[change.visitedPatterns addObject:self];
		
		if ([_pattern respondsToSelector:@selector(updateRecursiveAttributes:)])
			[(id<HammerDerivativePattern>)_pattern updateRecursiveAttributes:change];
	}
	
#define HammerDidAttributeChange(x) [_pattern respondsToSelector:@selector(x)] && (_ ## x != (_ ## x = ((id<HammerDerivativePattern>)_pattern).x))
	[change orWith:HammerDidAttributeChange(isNullable)];
	[change orWith:HammerDidAttributeChange(isNull)];
//	[change orWith:HammerDidAttributeChange(isEpsilon)];
#undef HammerDidAttributeChange
}


-(BOOL)isNullable {
	[self memoizeRecursiveAttributes];
	return _isNullable;
}

-(BOOL)isNull {
	[self memoizeRecursiveAttributes];
	return _isNull;
}

//-(BOOL)isEpsilon {
//	[self memoizeRecursiveAttributes];
//	return _isEpsilon;
//}


-(NSString *)prettyPrintedDescription {
	return HammerPatternDescription(_pattern);
}


-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	id result = nil;
	if ([_pattern respondsToSelector:@selector(acceptVisitor:)])
		result = [(id<HammerVisitable>)_pattern acceptVisitor:visitor];
	else {
		[visitor visitObject:_pattern];
		result = [visitor leaveObject:_pattern withVisitedChildren:nil];
	}
	return result;
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
