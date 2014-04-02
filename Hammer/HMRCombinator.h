//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRDelay.h>

@protocol HMRCombinator <NSObject, NSCopying>

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object;
-(id<HMRCombinator>)derivative:(id<NSObject, NSCopying>)object;

-(NSSet *)reduceParseForest;
@property (readonly) NSSet *parseForest;

/// Produce a deeply compacted representation of the receiver.
-(id<HMRCombinator>)compact;
@property (readonly) id<HMRCombinator> compaction;

-(NSString *)describe;
@property (readonly) NSString *description;

@end


id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right);
id<HMRCombinator> HMRConcatenate(id<HMRCombinator> first, id<HMRCombinator> second);

id<HMRCombinator> HMRRepeat(id<HMRCombinator> combinator);

id<HMRCombinator> HMRReduce(id<HMRCombinator> combinator, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>));

id<HMRCombinator> HMRLiteral(id<NSObject, NSCopying> object);

id<HMRCombinator> HMRCaptureTree(id object);
id<HMRCombinator> HMRCaptureForest(NSSet *forest);

/// The empty combinator, i.e. a combinator which cannot match anything.
id<HMRCombinator> HMRNone(void);
