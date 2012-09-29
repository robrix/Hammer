//  HammerParserIsNullPredicate.m
//  Created by Rob Rix on 2012-09-20.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/Hammer.h>
#import "HammerLeastFixedPointVisitor.h"
#import "HammerParserIsNullPredicate.h"

@interface HammerParserIsNullPredicate () <HammerVisitor>
@end

@implementation HammerParserIsNullPredicate

+(instancetype)predicate {
	static HammerParserIsNullPredicate *predicate = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		predicate = [self new];
	});
	return predicate;
}

+(bool)isNull:(HammerParser *)parser {
	return [[parser acceptVisitor:[[HammerLeastFixedPointVisitor alloc] initWithBottom:@YES visitor:[self predicate]]] boolValue];
}

-(bool)isNull:(HammerLazyVisitable)child {
	return [[child() acceptVisitor:self] boolValue];
}


-(NSNumber *)emptyParser:(HammerEmptyParser *)parser {
	return @NO;
}

-(NSNumber *)nullParser:(HammerNullParser *)parser {
	return @YES;
}

-(NSNumber *)nullReductionParser:(HammerNullReductionParser *)parser {
	return @YES;
}

-(NSNumber *)termParser:(HammerTermParser *)parser {
	return @NO;
}


-(NSNumber *)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return @([self isNull:left] && [self isNull:right]);
}

-(NSNumber *)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return @([self isNull:first] && [self isNull:second]);
}

-(NSNumber *)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return @([self isNull:child]);
}

@end
