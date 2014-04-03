//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRCombinator <NSObject, NSCopying>

-(id<HMRCombinator>)derivative:(id<NSObject, NSCopying>)object;

@property (readonly) NSSet *parseForest;

@property (readonly) id<HMRCombinator> compaction;

@property (readonly) NSString *description;

@end


id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right);
id<HMRCombinator> HMRConcatenate(id<HMRCombinator> first, id<HMRCombinator> second);

id<HMRCombinator> HMRRepeat(id<HMRCombinator> combinator);

id<HMRCombinator> HMRReduce(id<HMRCombinator> combinator, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>));

id<HMRCombinator> HMRLiteral(id<NSObject, NSCopying> object);

id<HMRCombinator> HMRCaptureTree(id object);
id<HMRCombinator> HMRCaptureForest(NSSet *forest);

/// A delayed combinator. Lazily evaluated.
#define HMRDelay(x) \
	((__typeof__(x))HMRLazyCombinator(^{ return (x); }))

id<HMRCombinator> HMRLazyCombinator(id<HMRCombinator>(^)(void));

/// The empty combinator, i.e. a combinator which cannot match anything.
id<HMRCombinator> HMRNone(void);
