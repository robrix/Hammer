//  HammerParser.m
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEmptyParser.h"
#import "HammerParserIsEmptyPredicate.h"
#import "HammerParserIsNullablePredicate.h"
#import "HammerParserIsNullPredicate.h"
#import "HammerMemoization.h"
#import "HammerMemoizingVisitor.h"
#import "HammerParser.h"
#import "HammerParserCompactor.h"
#import "HammerParserFormatter.h"

id HammerKleeneFixedPoint(id(^f)(id previous), id bottom);

@implementation HammerParser {
	NSNumber *_isNullable;
	NSNumber *_isNull;
	NSNumber *_isEmpty;
	NSSet *_parseNull;
	NSMutableDictionary *_memoizedDerivativesByTerm;
}

-(id)init {
	if ((self = [super init]))
		_memoizedDerivativesByTerm = [NSMutableDictionary new];
	return self;
}


-(HammerParser *)parseDerive:(id)term {
	return [HammerEmptyParser parser];
}

-(HammerParser *)memoizeDerivative:(HammerParser *)value forTerm:(id)term {
	[_memoizedDerivativesByTerm setObject:value forKey:term];
	return value;
}


-(NSSet *)parseFull:(id<NSFastEnumeration>)sequence {
	HammerParser *parser = self;
	for (id term in sequence) {
		parser = [HammerParserCompactor compact:[parser parse:term]];
	}
	return [parser parseNull];
}

-(HammerParser *)parse:(id)term {
	return [_memoizedDerivativesByTerm objectForKey:term] ?: [self memoizeDerivative:[self parseDerive:term] forTerm:term];
}

-(NSSet *)parseNullRecursive {
	return [NSSet set];
}

-(NSSet *)parseNull {
	return HammerMemoizedValue(_parseNull, HammerKleeneFixedPoint(^(NSSet *previous) {
		_parseNull = previous;
		return [self parseNullRecursive];
	}, [NSSet set]));
}


-(bool)isNullable {
	return [HammerMemoizedValue(_isNullable, @([HammerParserIsNullablePredicate isNullable:self])) boolValue];
}

-(bool)isNull {
	return [HammerMemoizedValue(_isNull, @([HammerParserIsNullPredicate isNull:self])) boolValue];
}

-(bool)isEmpty {
	return [HammerMemoizedValue(_isEmpty, @([HammerParserIsEmptyPredicate isEmpty:self])) boolValue];
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}


-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	return nil;
}

@end


id HammerKleeneFixedPoint(id(^f)(id previous), id bottom) {
	BOOL changed = NO;
	do {
		changed = ![bottom isEqual:(bottom = f(bottom))];
	} while(changed);
	return bottom;
}
