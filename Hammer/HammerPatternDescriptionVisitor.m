//  HammerPatternDescriptionVisitor.m
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationPattern.h"
#import "HammerConcatenationPattern.h"
#import "HammerEpsilonPattern.h"
#import "HammerEqualsPattern.h"
#import "HammerNullPattern.h"
#import "HammerPatternDescriptionVisitor.h"
#import "HammerRepetitionPattern.h"

@implementation HammerPatternDescriptionVisitor

-(BOOL)visitObject:(id)object {
	return YES;
}

-(id)leaveObject:(id)pattern withVisitedChildren:(id)children {
	NSString *description = nil;
	if ([pattern isEqual:[HammerNullPattern pattern]])
		description = @"∅";
	else if ([pattern isEqual:[HammerEpsilonPattern pattern]])
		description = @"ε";
	else if ([pattern isKindOfClass:[HammerEqualsPattern class]])
		description = [[pattern object] description];
	else if ([pattern isKindOfClass:[HammerRepetitionPattern class]])
		description = [children stringByAppendingString:@"*"];
	else if ([pattern isKindOfClass:[HammerAlternationPattern class]])
		description = [children componentsJoinedByString:@" | "];
	else if ([pattern isKindOfClass:[HammerConcatenationPattern class]])
		description = [children componentsJoinedByString:@" "];
	return description ?: [pattern description];
}

@end
