//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRCombinator <NSObject, NSCopying>

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object;
-(id<HMRCombinator>)derivative:(id<NSObject, NSCopying>)object;

-(NSSet *)reduceParseForest;
@property (readonly) NSSet *parseForest;

-(NSString *)describe;
@property (readonly) NSString *description;

@end


id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right);
id<HMRCombinator> HMRConcatenate(id<HMRCombinator> first, id<HMRCombinator> second);

id<HMRCombinator> HMRRepeat(id<HMRCombinator> parser);

id<HMRCombinator> HMRReduce(id<HMRCombinator> parser, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>));

id<HMRCombinator> HMRLiteral(id<NSObject, NSCopying> object);

id<HMRCombinator> HMRDelay(id<HMRCombinator>(^block)());

id<HMRCombinator> HMRCaptureTree(id object);
id<HMRCombinator> HMRCaptureForest(NSSet *forest);

/// The empty parser, i.e. a combinator which cannot match anything.
id<HMRCombinator> HMRNone(void);
