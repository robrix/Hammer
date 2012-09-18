//  HammerMemoizingVisitor.m
//  Created by Rob Rix on 2012-07-07.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerMemoization.h"
#import "HammerMemoizingVisitor.h"
#import <Hammer/Hammer.h>

@interface HammerRedirectingVisitable : NSObject <HammerVisitable>
+(instancetype)visitableWithVisitable:(HammerLazyVisitable)visitable visitor:(id<HammerVisitor>)visitor;
@end


@implementation HammerMemoizingVisitor {
	id<HammerVisitor> _visitor;
	id<HammerSymbolizer> _symbolizer;
	NSMutableDictionary *_resultsByVisitedObject;
}


-(instancetype)initWithVisitor:(id<HammerVisitor>)visitor symbolizer:(id<HammerSymbolizer>)symbolizer {
	if ((self = [super init])) {
		_visitor = visitor;
		_symbolizer = symbolizer;
		_resultsByVisitedObject = [NSMutableDictionary new];
	}
	return self;
}


-(id)keyForParser:(HammerParser *)parser {
	return @((NSUInteger)(__bridge void *)parser);
}

-(id)valueForParser:(HammerParser *)parser memoizing:(id(^)())block {
	id key = [self keyForParser:parser];
	id value = [_resultsByVisitedObject objectForKey:key];
	if (!value) {
		id symbol = [_symbolizer symbolForObject:parser];
		[_resultsByVisitedObject setObject:symbol forKey:key];
		
		value = block();
	}
	return value;
}


-(HammerLazyVisitable)redirectVisitable:(HammerLazyVisitable)visitable {
	return HammerDelay([HammerRedirectingVisitable visitableWithVisitable:visitable visitor:self]);
}


-(id)emptyParser:(HammerEmptyParser *)parser {
	return [self valueForParser:parser memoizing:^id{
		return [_visitor emptyParser:parser];
	}];
}

-(id)nullParser:(HammerNullParser *)parser {
	return [self valueForParser:parser memoizing:^id{
		return [_visitor nullParser:parser];
	}];
}


-(id)nullReductionParser:(HammerNullReductionParser *)parser {
	return [self valueForParser:parser memoizing:^id{
		return [_visitor nullReductionParser:parser];
	}];
}


-(id)termParser:(HammerTermParser *)parser {
	return [self valueForParser:parser memoizing:^id{
		return [_visitor termParser:parser];
	}];
}


-(id)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [self valueForParser:parser memoizing:^id{
		return [_visitor alternationParser:parser withLeft:[self redirectVisitable:left] right:[self redirectVisitable:right]];
	}];
}

-(id)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [self valueForParser:parser memoizing:^id{
		return [_visitor concatenationParser:parser withFirst:[self redirectVisitable:first] second:[self redirectVisitable:second]];
	}];
}

-(id)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return [self valueForParser:parser memoizing:^id{
		return [_visitor reductionParser:parser withParser:[self redirectVisitable:child]];
	}];
}

@end


@implementation HammerRedirectingVisitable {
	HammerLazyVisitable _visitable;
	id<HammerVisitor> _visitor;
}

+(instancetype)visitableWithVisitable:(HammerLazyVisitable)visitable visitor:(id<HammerVisitor>)visitor {
	HammerRedirectingVisitable *instance = [self new];
	instance->_visitable = visitable;
	instance->_visitor = visitor;
	return instance;
}

-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	return [_visitable() acceptVisitor:_visitor];
}

@end
