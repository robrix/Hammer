//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRCombinator <NSObject, NSCopying>

-(id<HMRCombinator>)derivativeWithRespectToElement:(id)element;

-(NSSet *)deforest;

@end
