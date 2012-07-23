//  HammerDerivativePattern.m
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerNullPattern.h"
#import "HammerDerivativePattern.h"
#import "HammerEmptyPattern.h"
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
		
		BOOL changed = NO;
		do {
			changed = NO;
#define HammerDidAttributeChange(x) ([_pattern respondsToSelector:@selector(x)] && (_ ## x != (_ ## x = ((id<HammerDerivativePattern>)_pattern).x)))
			changed =
				changed
			||	HammerDidAttributeChange(isNullable)
			||	HammerDidAttributeChange(isNull);
#undef HammerDidAttributeChange
		} while(changed);
	}
}


-(BOOL)isNullable {
	[self memoizeRecursiveAttributes];
	return _isNullable;
}

-(BOOL)isNull {
	[self memoizeRecursiveAttributes];
	return _isNull;
}


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
