//  HammerLeastFixedPointVisitor.m
//  Created by Rob Rix on 2012-09-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerLeastFixedPointVisitor.h"
#import <Hammer/Hammer.h>

@interface HammerLeastFixedPointVisitor () <HammerVisitable>
@end

@implementation HammerLeastFixedPointVisitor {
	NSMutableDictionary *_resultsByVisitedObject;
	HammerLazyVisitable _currentVisitable;
}

-(instancetype)initWithBottom:(id)bottom visitor:(id<HammerVisitor>)visitor {
	if ((self = [super init])) {
		_bottom = bottom;
		_visitor = visitor;
		_resultsByVisitedObject = [NSMutableDictionary new];
	}
	return self;
}


-(id)emptyParser:(HammerEmptyParser *)parser {
	return [self cachedValueForParser:parser block:^id{
		return [self.visitor emptyParser:parser];
	}];
}

-(id)nullParser:(HammerNullParser *)parser {
	return [self cachedValueForParser:parser block:^id{
		return [self.visitor nullParser:parser];
	}];
}

-(id)nullReductionParser:(HammerNullReductionParser *)parser {
	return [self cachedValueForParser:parser block:^id{
		return [self.visitor nullReductionParser:parser];
	}];
}


-(id)termParser:(HammerTermParser *)parser {
	return [self cachedValueForParser:parser block:^id{
		return [self.visitor termParser:parser];
	}];
}


-(id)alternationParser:(HammerAlternationParser *)parser withLeft:(HammerLazyVisitable)left right:(HammerLazyVisitable)right {
	return [self cachedValueForParser:parser block:^id{
		return [self.visitor alternationParser:parser withLeft:[self redirectVisitable:left] right:[self redirectVisitable:right]];
	}];
}

-(id)concatenationParser:(HammerConcatenationParser *)parser withFirst:(HammerLazyVisitable)first second:(HammerLazyVisitable)second {
	return [self cachedValueForParser:parser block:^id{
		return [self.visitor concatenationParser:parser withFirst:[self redirectVisitable:first] second:[self redirectVisitable:second]];
	}];
}


-(id)reductionParser:(HammerReductionParser *)parser withParser:(HammerLazyVisitable)child {
	return [self cachedValueForParser:parser block:^id{
		return [self.visitor reductionParser:parser withParser:[self redirectVisitable:child]];
	}];
}


-(id)cachedValueForParser:(HammerParser *)parser block:(id(^)())block {
	id value = _resultsByVisitedObject[parser];
	if (!value) {
		value = _resultsByVisitedObject[parser] = self.bottom;
		bool changed = false;
		do {
			changed = ![value isEqual:(value = _resultsByVisitedObject[parser] = block())];
		} while(changed);
	}
	return value;
}


// redirect the destination visitor to recurse through us, rather than itself
// I have a feeling we could accomplish the same more cleanly with a HammerVisitor API change, but I’m not sure what that would look like just yet.
-(HammerLazyVisitable)redirectVisitable:(HammerLazyVisitable)visitable {
	return ^{
		_currentVisitable = visitable;
		return self;
	};
}

-(id)acceptVisitor:(id<HammerVisitor>)visitor {
	return [_currentVisitable() acceptVisitor:self];
}

@end
