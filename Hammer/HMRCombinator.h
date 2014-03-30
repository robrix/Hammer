//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRCombinator <NSObject, NSCopying>

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object;
-(id<HMRCombinator>)derivative:(id<NSObject, NSCopying>)object;

-(NSSet *)reduceParseForest;
@property (readonly) NSSet *parseForest;

-(NSString *)describe;
@property (readonly) NSString *description;

/// Produce a deeply compacted representation of the receiver.
///
/// In most cases this will simply return \c self, because compaction is initially applied in the constructors. However, lazy parsers or other proxies may wish to use this to return their inner combinator after they have been forced/resolved, where applying it too soon (e.g. in the constructor) could cause infinite recursion or otherwise negate the purpose of the combinator.
-(id<HMRCombinator>)compact;

@end


id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right);
id<HMRCombinator> HMRConcatenate(id<HMRCombinator> first, id<HMRCombinator> second);

id<HMRCombinator> HMRRepeat(id<HMRCombinator> combinator);

id<HMRCombinator> HMRReduce(id<HMRCombinator> combinator, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying>));

id<HMRCombinator> HMRLiteral(id<NSObject, NSCopying> object);

id<HMRCombinator> HMRDelay(id<HMRCombinator>(^block)());

id<HMRCombinator> HMRCaptureTree(id object);
id<HMRCombinator> HMRCaptureForest(NSSet *forest);

/// The empty combinator, i.e. a combinator which cannot match anything.
id<HMRCombinator> HMRNone(void);
