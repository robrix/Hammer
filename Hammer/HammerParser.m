//  HammerParser.m
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEmptyParser.h"
#import "HammerIdentitySymbolizer.h"
#import "HammerMemoization.h"
#import "HammerMemoizingVisitor.h"
#import "HammerParser.h"
#import "HammerParserDescriptionVisitor.h"

id HammerKleeneFixedPoint(id(^f)(id previous), id bottom);

@implementation HammerParser {
	BOOL _memoizedCanParseNull;
	BOOL _canParseNull;
	NSSet *_parseNull;
	BOOL _memoizedCompact;
	HammerParser *_compact;
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
		NSLog(@"parsing %@ with %@", term, [parser prettyPrint]);
		parser = [parser parse:term].compact;
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


-(BOOL)canParseNullRecursive {
	return NO;
}

-(BOOL)canParseNull {
	if (!_memoizedCanParseNull) {
		_memoizedCanParseNull = YES;
		_canParseNull = [HammerKleeneFixedPoint(^(NSNumber *previous) {
			_canParseNull = previous.boolValue;
			return @([self canParseNullRecursive]);
		}, @(NO)) boolValue];
	}
	return _canParseNull;
}


-(id)copyWithZone:(NSZone *)zone {
	return self;
}


-(id)acceptMemoizedVisitor:(id<HammerVisitor>)visitor {
	HammerMemoizingVisitor *memoizer = [[HammerMemoizingVisitor alloc] initWithVisitor:visitor symbolizer:[HammerIdentitySymbolizer symbolizer]];
	return [self acceptVisitor:memoizer];
}


-(NSString *)prettyPrint {
	return [self acceptMemoizedVisitor:[HammerParserDescriptionVisitor new]];
}


-(HammerParser *)compactRecursive {
	return self;
}

-(HammerParser *)compact {
	if (!_memoizedCompact) {
		_memoizedCompact = YES;
		_compact = self;
		_compact = self.compactRecursive;
	}
	return _compact;
}


-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	[visitor visitObject:self];
	return [visitor leaveObject:self withVisitedChildren:nil];
}

@end


id HammerKleeneFixedPoint(id(^f)(id previous), id bottom) {
	BOOL changed = NO;
	do {
		changed = ![bottom isEqual:(bottom = f(bottom))];
	} while(changed);
	return bottom;
}
