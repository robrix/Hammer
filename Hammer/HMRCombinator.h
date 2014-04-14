//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>
#import <Reducers/REDReducible.h>
#import <Hammer/HMRPredicate.h>

@protocol HMRCombinator <NSObject, NSCopying, REDReducible, HMRPredicate>

-(id<HMRCombinator>)derivative:(id<NSObject, NSCopying>)object;

@property (readonly) NSSet *parseForest;

@property (readonly) id<HMRCombinator> compaction;

@property (readonly) NSString *description;

@property (readonly) NSString *name;
-(instancetype)withName:(NSString *)name;

@property (readonly) NSUInteger hash;

@end


/// The type of a reduction combinator’s block, which maps parse trees.
typedef id (^HMRReductionBlock)(id<NSObject, NSCopying> each);


#pragma mark Constructors

/// Constructs the alternation of \c left and \c right.
///
/// Corresponds to a sum type, and the union of context-free languages.
///
/// \param left   An operand to the alternation. Must not be nil.
/// \param right  An operand to the alternation. Must not be nil.
/// \return       A combinator representing the union of \c left and \c right.
id<HMRCombinator> HMROr(id<HMRCombinator> left, id<HMRCombinator> right) __attribute__((nonnull));

/// Constructs the concatenation of \c left and \c right.
///
/// Corresponds to a product type, and the cartesian product of context-free languages.
///
/// \param first   The first operand to the concatenation. Must not be nil.
/// \param second  The second operand to the concatenation. Must not be nil.
/// \return        A combinator representing the concatenation of \c first and \c second.
id<HMRCombinator> HMRAnd(id<HMRCombinator> first, id<HMRCombinator> second) __attribute__((nonnull));

/// Constructs the repetition of \c combinator.
///
/// Corresponds to the Kleene star of \c combinator, i.e. zero or more repetitions.
///
/// \param combinator  The combinator to repeat. Must not be nil.
/// \return            A combinator representing the repetition of \c combinator.
id<HMRCombinator> HMRRepeat(id<HMRCombinator> combinator) __attribute__((nonnull));

/// Constructs the reduction of \c combinator by \c block.
///
/// Reductions map parse trees into a form more readily operated upon, e.g. abstract syntax trees.
///
/// \param combinator  The combinator to reduce. Must not be nil.
/// \param block       The block to map the parse trees produced by \c combinator with. Will be called pointwise, i.e. once per parse tree. Must not be nil.
/// \return            A combinator representing the reduction of \c combinator by \c block.
id<HMRCombinator> HMRMap(id<HMRCombinator> combinator, HMRReductionBlock) __attribute__((nonnull));


/// Constructs a literal combinator.
///
/// \param object  The object to compare input against. May be nil.
/// \return        A combinator which matches input equal to \c object by pointer equality or by \c -isEqual:.
id<HMRCombinator> HMREqual(id<NSObject, NSCopying> object);

/// Constructs a character set combinator.
///
/// \param characterSet  The character set to compare input against. Must not be nil.
/// \return              A combinator which matches strings whose characters are all within \c characterSet.
id<HMRCombinator> HMRContains(NSCharacterSet *characterSet) __attribute__((nonnull));


/// Constructs a null parse with a forest containing \c object.
///
/// This is rarely useful when constructing grammars.
///
/// \param object  The object to treat as having been parsed. Must not be nil.
/// \return        A null parse whose parse forest contains \c object as its sole parse tree.
id<HMRCombinator> HMRCaptureTree(id object) __attribute__((nonnull));

/// Constructs a null parse consisting of \c forest.
///
/// This is rarely useful when constructing grammars.
///
/// \param forest  The set of parse trees to treat as having been parsed. Must not be nil.
/// \return        A null parse consisting of \c forest.
id<HMRCombinator> HMRCaptureForest(NSSet *forest) __attribute__((nonnull));


/// A delayed combinator. Lazily evaluated.
///
/// This is a typesafe convenience for \c HMRLazyCombinator, and is considered preferable to the latter.
///
/// \param x  The nonterminal combinator to delay. Must not be nil.
/// \return   A proxy for the eventual evaluation of \c x.
#define HMRDelay(x) \
	((__typeof__(x))HMRLazyCombinator(^{ return (x); }))

/// A proxy for a lazily-evaluated combinator.
///
/// This is the mechanism by which the \c HMRDelay convenience macro operates. You should avoid using \c HMRLazyCombinator directly, and use \c HMRDelay instead.
///
/// \param delayed  A block returning the combinator to delay the evaluation of. Must not be nil, and must not return nil.
/// \return         A proxy for the lazy-evaluated result of \c delayed.
id<HMRCombinator> HMRLazyCombinator(id<HMRCombinator>(^delayed)(void)) __attribute__((nonnull));


/// The empty combinator, i.e. a combinator which cannot match anything.
id<HMRCombinator> HMRNone(void);
