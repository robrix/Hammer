//  RXTrait.m
//  Created by Rob Rix on 12-07-17.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "RXTrait.h"
#import <objc/runtime.h>

NSString *RXTraitSubclassName(Class<RXTrait> trait, Class targetClass) {
	return [NSString stringWithFormat:@"RXTraitSubclassApplying_%@_To_%@", trait, targetClass];
}

Class RXTraitCreateSubclassOfTargetClass(Class<RXTrait> trait, Class targetClass) {
	Class subclass = objc_allocateClassPair(targetClass, RXTraitSubclassName(trait, targetClass).UTF8String, 0);
	
	unsigned methodCount = 0;
	Method *methods = class_copyMethodList(trait, &methodCount);
	for(unsigned i = 0; i < methodCount; i++) {
		Method method = methods[i];
		SEL selector = method_getName(method);
		if (!class_respondsToSelector(targetClass, selector))
			class_addMethod(subclass, selector, method_getImplementation(method), method_getTypeEncoding(method));
	}
	class_addProtocol(subclass, [trait traitProtocol]);
	objc_registerClassPair(subclass);
	return subclass;
}

Class RXTraitSubclassOfTargetClass(Class<RXTrait> trait, Class targetClass) {
	return
		NSClassFromString(RXTraitSubclassName(trait, targetClass))
	?:	RXTraitCreateSubclassOfTargetClass(trait, targetClass);
}

BOOL RXTraitIsAlreadyApplied(Class<RXTrait> trait, Class targetClass) {
	return [NSStringFromClass(targetClass) rangeOfString:@"RXTraitSubclassApplying_"].location != NSNotFound;
}

id RXTraitApply(Class<RXTrait> trait, id target) {
	Class targetClass = [target class];
	if (([trait targetProtocol] == nil) || [target conformsToProtocol:[trait targetProtocol]]) {
		if (!RXTraitIsAlreadyApplied(trait, targetClass)) {
			object_setClass(target, RXTraitSubclassOfTargetClass(trait, targetClass));
		}
	} else
		target = nil;
	return target;
}
