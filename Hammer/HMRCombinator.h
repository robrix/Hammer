//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRLaziness.h>

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


typedef id<HMRCombinator> (^HMRLazyCombinator)();

id<HMRCombinator> HMRAlternate(HMRLazyCombinator lazyLeft, HMRLazyCombinator lazyRight);
id<HMRCombinator> HMRConcatenate(HMRLazyCombinator lazyFirst, HMRLazyCombinator lazySecond);

id<HMRCombinator> HMRRepeat(HMRLazyCombinator lazyCombinator);

id<HMRCombinator> HMRReduce(HMRLazyCombinator lazyCombinator, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>));

id<HMRCombinator> HMRLiteral(id<NSObject, NSCopying> object);

id<HMRCombinator> HMRCaptureTree(id object);
id<HMRCombinator> HMRCaptureForest(NSSet *forest);

/// The empty combinator, i.e. a combinator which cannot match anything.
id<HMRCombinator> HMRNone(void);
