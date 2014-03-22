//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRCombinator <NSObject>

-(id<HMRCombinator>)derivativeWithRespectToElement:(id)element;

-(NSSet *)deforest;

@end
