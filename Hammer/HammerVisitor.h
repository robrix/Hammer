//  HammerVisitor.h
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HammerVisitable;
@protocol HammerVisitor <NSObject>

// BOOL return value indicates whether it should also visit its children; -leaveObject:withVisitedChildren: will be called regardless. This allows memoization and therefore visiting cyclic graphs.
-(BOOL)visitObject:(id)object;
// returned object becomes the result of -acceptVisitor:, and is passed into the parent’s children parameter when it is left. This allows convenient piecewise recursive construction of results given a graph, reusing the call stack instead of having to construct its own stack.
-(id)leaveObject:(id)object withVisitedChildren:(id)children;

@end

@protocol HammerVisitable <NSObject>

// calls -visitObject:, any children (if -visitObject: returned YES), and then -leaveObject:withVisitedChildren: passing it the results for its children.
// returns the value returned to it by -leaveObject:withVisitedChildren:.
// this method is therefore purely structural, controlling how a visitor walks the receiver and its children.
-(id)acceptVisitor:(id<HammerVisitor>)visitor;

@end
