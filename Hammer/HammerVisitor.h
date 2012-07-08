//  HammerVisitor.h
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>

@protocol HammerVisitor <NSObject>

-(BOOL)visitPattern:(id<HammerPattern>)pattern;
-(id)leavePattern:(id<HammerPattern>)pattern withVisitedChildren:(id)children;

@end

@protocol HammerVisitable <NSObject>

-(id)acceptVisitor:(id<HammerVisitor>)visitor;

@end
