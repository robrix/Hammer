//  HammerParserIsNullablePredicate.m
//  Created by Rob Rix on 2012-09-29.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerParserIsNullablePredicate.h"
#import "HammerLeastFixedPointVisitor.h"
#import <Hammer/Hammer.h>

@interface HammerParserIsNullablePredicate () <HammerVisitor>
@end

@implementation HammerParserIsNullablePredicate

+(instancetype)predicate {
	static HammerParserIsNullablePredicate *predicate = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		predicate = [self new];
	});
	return predicate;
}

+(bool)isNullable:(HammerParser *)parser {
	return [[parser acceptVisitor:[[HammerLeastFixedPointVisitor alloc] initWithBottom:@NO visitor:[self predicate]]] boolValue];
}

-(bool)isNullable:(HammerLazyVisitable)child {
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
	return @([self isNullable:left] || [self isNullable:right]);
}

-(NSNumber *)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return @([self isNullable:first] && [self isNullable:second]);
}

-(NSNumber *)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return @([self isNullable:child]);
}

@end
