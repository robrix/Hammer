//  HammerParserIsEmptyPredicate.m
//  Created by Rob Rix on 2012-09-29.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "Hammer.h"
#import "HammerLeastFixedPointVisitor.h"
#import "HammerParserIsEmptyPredicate.h"

@interface HammerParserIsEmptyPredicate () <HammerVisitor>
@end

@implementation HammerParserIsEmptyPredicate

+(instancetype)predicate {
	static HammerParserIsEmptyPredicate *predicate = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		predicate = [self new];
	});
	return predicate;
}

+(bool)isEmpty:(HammerParser *)parser {
	return [[parser acceptVisitor:[[HammerLeastFixedPointVisitor alloc] initWithBottom:@YES visitor:[self predicate]]] boolValue];
}

-(bool)isEmpty:(HammerLazyVisitable)child {
	return [[child() acceptVisitor:self] boolValue];
}


-(id)emptyParser:(HammerEmptyParser *)parser {
	return @YES;
}

-(id)nullParser:(HammerNullParser *)parser {
	return @NO;
}

-(id)nullReductionParser:(HammerNullReductionParser *)parser {
	return @NO;
}


-(id)termParser:(HammerTermParser *)parser {
	return @NO;
}


-(id)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return @([self isEmpty:left] && [self isEmpty:right]);
}

-(id)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return @([self isEmpty:first] || [self isEmpty:second]);
}

-(id)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return @([self isEmpty:child]);
}

@end
