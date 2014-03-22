//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRCombinator <NSObject, NSCopying>

-(id<HMRCombinator>)derivativeWithRespectToElement:(id<NSObject, NSCopying>)element;

-(NSSet *)deforest;

@end


extern id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right);
extern id<HMRCombinator> HMRConcatenate(id<HMRCombinator> left, id<HMRCombinator> right);

extern id<HMRCombinator> HMRRepeat(id<HMRCombinator> parser);

extern id<HMRCombinator> HMRReduce(id<HMRCombinator> parser, id(^block)(id));

extern id<HMRCombinator> HMRLiteral(id element);

extern id<HMRCombinator> HMRDelay(id<HMRCombinator>(^block)());
