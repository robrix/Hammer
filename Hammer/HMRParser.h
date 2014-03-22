//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@interface HMRParser : NSObject <NSCopying>

@property (readonly, getter = isNullable) bool nullable;
@property (readonly, getter = isNull) bool null;
@property (readonly, getter = isEmpty) bool empty;

-(HMRParser *)parse:(id)element;

@end
