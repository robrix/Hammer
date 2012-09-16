//  HammerMemoizingVisitor.m
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerMemoization.h"
#import "HammerMemoizingVisitor.h"

@interface HammerRedirectingVisitable : NSObject <HammerVisitable>
+(instancetype)visitableWithVisitable:(HammerLazyVisitable)visitable visitor:(id<HammerParserAlgebra>)visitor;
@end


@implementation HammerMemoizingVisitor {
	id<HammerParserAlgebra> _visitor;
	id<HammerSymbolizer> _symbolizer;
	NSMutableDictionary *_resultsByVisitedObject;
}


-(instancetype)initWithVisitor:(id<HammerParserAlgebra>)visitor symbolizer:(id<HammerSymbolizer>)symbolizer {
	if ((self = [super init])) {
		_visitor = visitor;
		_symbolizer = symbolizer;
		_resultsByVisitedObject = [NSMutableDictionary new];
	}
	return self;
}


-(id)valueForTuple:(id)tuple memoizing:(id(^)())block {
	id value = [_resultsByVisitedObject objectForKey:tuple];
	if (!value) {
		id symbol = [_symbolizer symbolForObject:tuple];
		[_resultsByVisitedObject setObject:symbol forKey:tuple];
		
		value = block();
	}
	return value;
}


-(HammerLazyVisitable)redirectVisitable:(HammerLazyVisitable)visitable {
	return HammerDelay([HammerRedirectingVisitable visitableWithVisitable:visitable visitor:self]);
}


-(id)emptyParser {
	return [self valueForTuple:@[@"HammerEmptyParser"] memoizing:^id{
		return [_visitor emptyParser];
	}];
}

-(id)nullParser {
	return [self valueForTuple:@[@"HammerNullParser"] memoizing:^id{
		return [_visitor nullParser];
	}];
}


-(id)nullReductionParserWithTrees:(NSSet *)trees {
	return [self valueForTuple:@[@"HammerNullReductionParser", trees] memoizing:^id{
		return [_visitor nullReductionParserWithTrees:trees];
	}];
}


-(id)termParserWithTerm:(id)term {
	return [self valueForTuple:@[@"HammerTermParser", term] memoizing:^id{
		return [_visitor termParserWithTerm:term];
	}];
}


-(id)alternationParserWithLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [self valueForTuple:@[@"HammerAlternationParser", left, right] memoizing:^id{
		return [_visitor alternationParserWithLeft:[self redirectVisitable:left] right:[self redirectVisitable:right]];
	}];
}

-(id)concatenationParserWithFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [self valueForTuple:@[@"HammerConcatenationParser", first, second] memoizing:^id{
		return [_visitor concatenationParserWithFirst:[self redirectVisitable:first] second:[self redirectVisitable:second]];
	}];
}

-(id)reductionParserWithParser:(HammerLazyVisitable)parser function:(HammerReductionFunction)function {
	return [self valueForTuple:@[@"HammerReductionParser", parser, function] memoizing:^id{
		return [_visitor reductionParserWithParser:[self redirectVisitable:parser] function:function];
	}];
}

@end


@implementation HammerRedirectingVisitable {
	HammerLazyVisitable _visitable;
	id<HammerParserAlgebra> _visitor;
}

+(instancetype)visitableWithVisitable:(HammerLazyVisitable)visitable visitor:(id<HammerParserAlgebra>)visitor {
	HammerRedirectingVisitable *instance = [self new];
	instance->_visitable = visitable;
	instance->_visitor = visitor;
	return instance;
}

-(id)acceptAlgebra:(id<HammerParserAlgebra>)algebra {
	return [_visitable() acceptAlgebra:_visitor];
}

@end
