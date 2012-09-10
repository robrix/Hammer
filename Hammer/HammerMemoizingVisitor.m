//  HammerMemoizingVisitor.m
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerMemoization.h"
#import "HammerMemoizingVisitor.h"

@interface HammerSymbolizedValue : NSObject

+(instancetype)valueWithObject:(id)object symbolizer:(id<HammerSymbolizer>)symbolizer;

@property (nonatomic, readonly, getter = hasMemoized) BOOL memoized;

-(void)visit;
-(id)leaveWithMemoizer:(id(^)())block;

@end

@implementation HammerMemoizingVisitor {
	id<HammerVisitor> _visitor;
	id<HammerSymbolizer> _symbolizer;
	NSMutableDictionary *_resultsByVisitedObject;
}

+(id)nullPlaceholder {
	static id placeholder = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		placeholder = [NSObject new];
	});
	return placeholder;
}


-(instancetype)initWithVisitor:(id<HammerVisitor>)visitor symbolizer:(id<HammerSymbolizer>)symbolizer {
	if ((self = [super init])) {
		_visitor = visitor;
		_symbolizer = symbolizer;
		_resultsByVisitedObject = [NSMutableDictionary new];
	}
	return self;
}


-(id<NSCopying>)keyForVisitableObject:(id<HammerVisitable>)object {
	return [NSNumber numberWithUnsignedInteger:(NSUInteger)object];
}

-(HammerSymbolizedValue *)resultForVisitedObject:(id<HammerVisitable>)object {
	return [_resultsByVisitedObject objectForKey:[self keyForVisitableObject:object]];
}

-(HammerSymbolizedValue *)memoizePlaceholderValueForVisitedObject:(id<HammerVisitable>)object {
	HammerSymbolizedValue *value = [HammerSymbolizedValue valueWithObject:object symbolizer:_symbolizer];
	[_resultsByVisitedObject setObject:value forKey:[self keyForVisitableObject:object]];
	return value;
}


-(BOOL)visitObject:(id)object {
	BOOL shouldRecurse = NO;
	HammerSymbolizedValue *memoizedValue = [self resultForVisitedObject:object];
	if (!memoizedValue) {
		memoizedValue = [self memoizePlaceholderValueForVisitedObject:object];
		shouldRecurse = [_visitor visitObject:object];
	}
	[memoizedValue visit];
	return shouldRecurse;
}

-(id)leaveObject:(id)object withVisitedChildren:(id)children {
	HammerSymbolizedValue *memoizedValue = [self resultForVisitedObject:object];
	id result = [memoizedValue leaveWithMemoizer:^{
		return [_visitor leaveObject:object withVisitedChildren:children];
	}];
	return result == [self.class nullPlaceholder]?
		nil
	:	result;
}

@end


@implementation HammerSymbolizedValue {
	id _object;
	id _symbol;
	NSUInteger _visitCount;
	id<HammerSymbolizer> _symbolizer;
}

+(instancetype)valueWithObject:(id)object symbolizer:(id<HammerSymbolizer>)symbolizer {
	HammerSymbolizedValue *value = [self new];
	value->_object = object;
	value->_symbolizer = symbolizer;
	return value;
}

@synthesize memoized = _memoized;

-(id)symbol {
	return HammerMemoizedValue(_symbol, [_symbolizer symbolForObject:_object]);
}


-(void)visit {
	_visitCount++;
}

-(id)leaveWithMemoizer:(id(^)())block {
	_visitCount--;
	return (_visitCount == 0)?
		block()
	:	[self symbol];
}

@end
