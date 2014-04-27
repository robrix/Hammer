//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Reducers/REDReducible.h>
#import <Hammer/HMRPredicate.h>
#import <Hammer/HMRSet.h>

/// The type of a reduction combinator’s block, which maps parse forests.
typedef id<REDReducible> (^HMRReductionBlock)(id<REDReducible> forest);

@class HMRAlternation, HMRIntersection, HMRConcatenation, HMRReduction, HMRRepetition;
@class HMREmpty, HMRNull, HMRPredicateCombinator, HMRLiteral, HMRContainment;

@interface HMRCombinator : NSObject <NSObject, NSCopying, REDReducible, HMRPredicate>

-(HMRCombinator *)derivative:(id<NSObject, NSCopying>)object;

@property (readonly) NSSet *parseForest;

@property (readonly) HMRCombinator *compaction;

/// Whether the receiver is cyclic.
///
/// \return  \c YES if the receiver is cyclic, \c NO otherwise.
@property (readonly, getter = isCyclic) bool cyclic;


#pragma mark Terminal construction

/// The empty combinator, i.e. a combinator which cannot match anything.
+(HMREmpty *)empty;

/// The null combinator, i.e. a combinator which matches the null (empty) string, ε.
+(HMRNull *)null;


/// Constructs a literal combinator.
///
/// \param object  The object to compare input against. May be nil.
/// \return        A combinator which matches input equal to \c object by pointer equality or by \c -isEqual:.
+(HMRLiteral *)literal:(id<NSObject,NSCopying>)object;

/// Constructs a containment combinator.
///
/// \param set  The set to compare input against. Must not be nil.
/// \return     A combinator which matches objects contained in \c set.
+(HMRContainment *)containedIn:(id<HMRSet>)set;


/// Constructs a null parse with a forest containing \c object.
///
/// This is rarely useful when constructing grammars.
///
/// \param object  The object to treat as having been parsed. Must not be nil.
/// \return        A null parse whose parse forest contains \c object as its sole parse tree.
+(HMRNull *)captureTree:(id)object;

/// Constructs a null parse consisting of \c forest.
///
/// This is rarely useful when constructing grammars.
///
/// \param forest  The set of parse trees to treat as having been parsed. Must not be nil.
/// \return        A null parse consisting of \c forest.
+(HMRNull *)capture:(NSSet *)forest;


#pragma mark Nonterminal construction

/// Constructs the alternation of \c self and \c other.
///
/// Corresponds to a sum type, and the union of context-free languages.
///
/// \param other  An operand to the alternation. Must not be nil.
/// \return       A combinator representing the union of \c self and \c other.
-(HMRAlternation *)or:(HMRCombinator *)other;

/// Constructs the alternation of a collection of combinators.
///
/// \param operands  A collection of operands to the alternation. Must not be empty. Must not be nil.
/// \return          A combinator representing the union of all the combinators in \c operands.
+(HMRCombinator *)alternate:(id<REDReducible>)operands;

/// Constructs the intersection of \c self and \c other.
///
/// Corresponds to the intersection of context-free languages.
///
/// \param other  An operand to the intersection. Must not be nil.
/// \return       A combinator representing the intersection of \c self and \c other.
-(HMRIntersection *)and:(HMRCombinator *)other;

/// Constructs the itnersection of a variadic list of combinators.
///
/// \param leftmost  The leftmost operand to the intersection. Must not be nil.
/// \return          A combinator representing the intersection of all the passed combinators.
+(HMRCombinator *)intersect:(HMRCombinator *)leftmost, ... NS_REQUIRES_NIL_TERMINATION;

/// Constructs the concatenation of \c self and \c other.
///
/// Corresponds to a product type, and the cartesian product of context-free languages.
///
/// \param second  The second operand to the concatenation. Must not be nil.
/// \return        A combinator representing the concatenation of \c self and \c other.
-(HMRConcatenation *)concat:(HMRCombinator *)other;

/// Constructs the concatenation of a collection of combinators.
///
/// \param operands  A collection of operands to the concatenation. Must not be empty. Must not be nil.
/// \return          A combinator representing the concatenation of all the combinators in \c operands.
+(HMRCombinator *)concatenate:(id<REDReducible>)operands;


/// Constructs the setwise reduction of \c self by \c block.
///
/// Reductions map parse trees into a form more readily operated upon, e.g. abstract syntax trees.
///
/// \param block  The block to map the parse trees produced by \c self with. Will be called setwise, i.e. once per parse forest. Must not be nil.
/// \return       A combinator representing the reduction of \c self by \c block.
-(HMRReduction *)mapSet:(HMRReductionBlock)block;

/// Constructs the pointwise reduction of \c self by \c block.
///
/// Reductions map parse trees into a form more readily operated upon, e.g. abstract syntax trees.
///
/// \param block  The block to map the parse trees produced by \c self with. Will be called pointwise, i.e. once per parse tree. Must not be nil.
/// \return       A combinator representing the reduction of \c self by \c block.
-(HMRReduction *)map:(REDMapBlock)block;


/// Constructs the repetition of \c self.
///
/// Corresponds to the Kleene star of \c self, i.e. zero or more repetitions.
///
/// \return  A combinator representing the repetition of \c self.
-(HMRRepetition *)repeat;


#pragma mark Conveniences

/// Constructs a combinator which parses the receiver but ignores any parse trees it produces.
///
/// \return  A reduction which ignores all of the receiver’s parse trees
-(HMRReduction *)ignore;


/// Constructs the alternation of the receiver and the null combinator.
///
/// Equivalent to '?' in regular expression syntax.
-(HMRAlternation *)optional;


#pragma mark Predicate construction

/// Constructs a combinator to match instances of the receiver.
+(HMRCombinator *)quote;

/// Constructs a combinator to match the receiver.
///
/// For example, \code[[a and:b] quote]\endcode returns a combinator which will match \c HMRConcatenation instances whose \c first property is matched by \c a and whose \c second property is matched by \c b. This is performed shallowly.
///
/// \c return  A combinator which matches the structure of the receiver.
-(HMRCombinator *)quote;


#pragma mark Pretty-printing

@property (readonly) NSString *name;
-(instancetype)withName:(NSString *)name;

@end


#pragma mark Constructors

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
HMRCombinator *HMRLazyCombinator(HMRCombinator *(^delayed)(void)) __attribute__((nonnull));
