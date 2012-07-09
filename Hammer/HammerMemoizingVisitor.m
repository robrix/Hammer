//  HammerMemoizingVisitor.m
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerMemoizingVisitor.h"

@interface HammerMemoizingVisitorValue : NSObject
@property (nonatomic, strong) id value;
@end

@implementation HammerMemoizingVisitor {
	id<HammerVisitor> _visitor;
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


-(instancetype)initWithVisitor:(id<HammerVisitor>)visitor {
	if ((self = [super init])) {
		_visitor = visitor;
		_resultsByVisitedObject = [NSMutableDictionary new];
	}
	return self;
}


-(id<NSCopying>)keyForVisitableObject:(id<HammerVisitable>)object {
	return [object conformsToProtocol:@protocol(NSCopying)]?
		(id<NSCopying>)object
	:	[NSNumber numberWithUnsignedInteger:(NSUInteger)object];
}

-(HammerMemoizingVisitorValue *)resultForVisitedObject:(id<HammerVisitable>)object {
	return [_resultsByVisitedObject objectForKey:[self keyForVisitableObject:object]];
}

-(void)memoizePlaceholderValueForVisitedObject:(id<HammerVisitable>)object {
	[_resultsByVisitedObject setObject:[HammerMemoizingVisitorValue new] forKey:[self keyForVisitableObject:object]];
}

-(id)memoizeResultValue:(id)result forVisitedObject:(id<HammerVisitable>)object {
	return [self resultForVisitedObject:object].value = result ?: [self.class nullPlaceholder];
}


-(BOOL)visitObject:(id)object {
	BOOL shouldRecurse = NO;
	if (![self resultForVisitedObject:object]) {
		[self memoizePlaceholderValueForVisitedObject:object];
		shouldRecurse = [_visitor visitObject:object];
	}
	return shouldRecurse;
}

-(id)leaveObject:(id)object withVisitedChildren:(id)children {
	id result = [self resultForVisitedObject:object].value ?: [self memoizeResultValue:[_visitor leaveObject:object withVisitedChildren:children] forVisitedObject:object];
	return result == [self.class nullPlaceholder]?
		nil
	:	result;
}

@end


@implementation HammerMemoizingVisitorValue
@synthesize value = _value;
@end
