//  RXTraitDecorator.m
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "RXTraitDecorator.h"
#import <objc/runtime.h>

@implementation RXTraitDecorator {
	id _object;
	id<RXTrait> _trait;
}

+(id)decorateObject:(id)object withTrait:(id<RXTrait>)trait {
	RXTraitDecorator *decorator = [[self alloc] init];
	decorator->_object = object;
	decorator->_trait = trait;
	return decorator;
}

-(id)init {
	return self;
}


-(BOOL)conformsToProtocol:(Protocol *)protocol {
	return protocol_isEqual(protocol, [_trait.class traitProtocol]);
}


-(id)forwardingTargetForSelector:(SEL)selector {
	id target = nil;
	if ([_object respondsToSelector:selector])
		target = _object;
	else if ([_trait respondsToSelector:selector])
		target = _trait;
	return target;
}

@end


//id RXTraitApply(Class<RXTrait> trait, id target) {
//	return [RXTraitDecorator decorateObject:target withTrait:[trait new]];
//}
