//  HammerMemoizingVisitor.m
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerMemoizingVisitor.h"

@interface HammerMemoizedValue : NSObject
@property (nonatomic, strong) id value;
@property (nonatomic, getter = isVisiting) BOOL visiting;

-(id)memoize:(id(^)())block symbol:(id(^)())symbol;

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
	return [object conformsToProtocol:@protocol(NSCopying)]?
		(id<NSCopying>)object
	:	[NSNumber numberWithUnsignedInteger:(NSUInteger)object];
}

-(HammerMemoizedValue *)resultForVisitedObject:(id<HammerVisitable>)object {
	return [_resultsByVisitedObject objectForKey:[self keyForVisitableObject:object]];
}

-(HammerMemoizedValue *)memoizePlaceholderValueForVisitedObject:(id<HammerVisitable>)object {
	HammerMemoizedValue *value = [HammerMemoizedValue new];
	[_resultsByVisitedObject setObject:value forKey:[self keyForVisitableObject:object]];
	value.visiting = YES;
	return value;
}


-(BOOL)visitObject:(id)object {
	BOOL shouldRecurse = NO;
	HammerMemoizedValue *memoizedValue = [self resultForVisitedObject:object];
	if (!memoizedValue) {
		memoizedValue = [self memoizePlaceholderValueForVisitedObject:object];
		shouldRecurse = [_visitor visitObject:object];
	}
	return shouldRecurse;
}

-(id)leaveObject:(id)object withVisitedChildren:(id)children {
	HammerMemoizedValue *memoizedValue = [self resultForVisitedObject:object];
	id result = [memoizedValue memoize:^{
		return [_visitor leaveObject:object withVisitedChildren:children];
	} symbol:^{
		return [_symbolizer symbolForObject:object];
	}];
	return result == [self.class nullPlaceholder]?
		nil
	:	result;
}

@end


@implementation HammerMemoizedValue
@synthesize value = _value;
@synthesize visiting = _visiting;

-(id)memoize:(id(^)())block symbol:(id(^)())placeholder {
	return self.isVisiting?
		self.value = block()
	:	self.value ?: placeholder();
}

@end
