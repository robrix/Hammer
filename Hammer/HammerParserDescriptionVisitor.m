//  HammerParserDescriptionVisitor.m
//  Created by Rob Rix on 2012-08-19.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerAlternationParser.h"
#import "HammerConcatenationParser.h"
#import "HammerEmptyParser.h"
#import "HammerNullParser.h"
#import "HammerParserDescriptionVisitor.h"
#import "HammerRepetitionParser.h"
#import "HammerTermParser.h"

@implementation HammerParserDescriptionVisitor

-(BOOL)visitObject:(id)object {
	return YES;
}

-(id)leaveObject:(id)parser withVisitedChildren:(id)children {
	NSString *description = nil;
	if ([parser isEqual:[HammerEmptyParser parser]])
		description = @"∅";
	else if ([parser isEqual:[HammerNullParser parser]])
		description = @"ε";
	else if ([parser isKindOfClass:[HammerTermParser class]])
		description = [NSString stringWithFormat:@"'%@'", [[parser term] description]];
	else if ([parser isKindOfClass:[HammerRepetitionParser class]])
		description = [children stringByAppendingString:@"*"];
	else if ([parser isKindOfClass:[HammerAlternationParser class]])
		description = children? [NSString stringWithFormat:@"{%@}", [children componentsJoinedByString:@" | "]] : nil;
	else if ([parser isKindOfClass:[HammerConcatenationParser class]])
		description = children? [NSString stringWithFormat:@"(%@)", [children componentsJoinedByString:@" "]] : nil;
	return description ?: [parser description];
}

@end
