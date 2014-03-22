//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@interface HMRParser : NSObject <NSCopying>

-(NSSet *)parseCollection:(id<NSFastEnumeration>)enumerator;
-(HMRParser *)parse:(id)element;

@end
