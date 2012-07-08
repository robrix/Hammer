//  HammerMemoizingVisitor.m
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerMemoizingVisitor.h"

@implementation HammerMemoizingVisitor {
	id<HammerVisitor> _visitor;
	NSMutableDictionary *_resultsByVisitedObject;
}

-(instancetype)initWithVisitor:(id<HammerVisitor>)visitor {
	if ((self = [super init])) {
		_resultsByVisitedObject = [NSMutableDictionary new];
	}
	return self;
}


-(id<NSCopying>)keyForVisitableObject:(id<HammerVisitable>)object {
	return [object conformsToProtocol:@protocol(NSCopying)]?
		(id<NSCopying>)object
	:	[NSValue valueWithPointer:(__bridge const void *)object];
}

-(id)resultForVisitedObject:(id<HammerVisitable>)object {
	return [_resultsByVisitedObject objectForKey:[self keyForVisitableObject:object]];
}

-(id)memoizeResult:(id)result forVisitedObject:(id<HammerVisitable>)object {
	[_resultsByVisitedObject setObject:result forKey:[self keyForVisitableObject:object]];
	return result;
}


-(BOOL)visitObject:(id)object {
	return [self resultForVisitedObject:object]?
		NO
	:	[_visitor visitObject:object];
}

-(id)leaveObject:(id)object withVisitedChildren:(id)children {
	return [self resultForVisitedObject:object] ?: [self memoizeResult:[_visitor leaveObject:object withVisitedChildren:children] forVisitedObject:object];
}

@end
