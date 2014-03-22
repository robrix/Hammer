//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRCombinator <NSObject, NSCopying>

-(id<HMRCombinator>)derivativeWithRespectToElement:(id<NSObject, NSCopying>)element;
-(id<HMRCombinator>)memoizedDerivativeWithRespectToElement:(id<NSObject, NSCopying>)element;

-(NSSet *)deforest;
-(NSSet *)memoizedDeforest;

-(id<HMRCombinator>)compact;
@property (readonly) id<HMRCombinator> compaction;

-(NSString *)describe;
@property (readonly) NSString *description;

@end


id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right);
id<HMRCombinator> HMRConcatenate(id<HMRCombinator> first, id<HMRCombinator> second);

id<HMRCombinator> HMRRepeat(id<HMRCombinator> parser);

id<HMRCombinator> HMRReduce(id<HMRCombinator> parser, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>));

id<HMRCombinator> HMRLiteral(id<NSObject, NSCopying> element);

id<HMRCombinator> HMRDelay(id<HMRCombinator>(^block)());
