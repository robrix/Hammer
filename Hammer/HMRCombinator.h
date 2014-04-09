//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRCombinator <NSObject, NSCopying>

-(id<HMRCombinator>)derivative:(id<NSObject, NSCopying>)object;

@property (readonly, getter = isNullable) bool nullable;
@property (readonly, getter = isCyclic) bool cyclic;

@property (readonly) NSSet *parseForest;

@property (readonly) id<HMRCombinator> compaction;

@property (readonly) NSString *description;
@property (readonly) NSOrderedSet *prettyPrinted;

@property (readonly) NSString *name;
-(instancetype)withName:(NSString *)name;

@end


id<HMRCombinator> HMRAlternate(id<HMRCombinator> left, id<HMRCombinator> right) __attribute__((nonnull));
id<HMRCombinator> HMRConcatenate(id<HMRCombinator> first, id<HMRCombinator> second) __attribute__((nonnull));

id<HMRCombinator> HMRRepeat(id<HMRCombinator> combinator) __attribute__((nonnull));

id<HMRCombinator> HMRReduce(id<HMRCombinator> combinator, id<NSObject, NSCopying>(^block)(id<NSObject, NSCopying> each)) __attribute__((nonnull));

id<HMRCombinator> HMRLiteral(id<NSObject, NSCopying> object);

/// Constructs a character set combinator.
///
/// \param characterSet The character set to compare input against.
/// \return A combinator which matches strings whose characters are all within \c characterSet.
id<HMRCombinator> HMRCharacterSet(NSCharacterSet *characterSet);


id<HMRCombinator> HMRCaptureTree(id object);
id<HMRCombinator> HMRCaptureForest(NSSet *forest);


/// A delayed combinator. Lazily evaluated.
#define HMRDelay(x) \
	((__typeof__(x))HMRLazyCombinator(^{ return (x); }))

id<HMRCombinator> HMRLazyCombinator(id<HMRCombinator>(^)(void)) __attribute__((nonnull));


/// The empty combinator, i.e. a combinator which cannot match anything.
id<HMRCombinator> HMRNone(void);
