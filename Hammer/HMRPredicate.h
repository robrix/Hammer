//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

/// An object which can evaluate objects, taking some action if it matches some predicate. Semantically similar to an “if/then” statement, but with a return value.
@protocol HMRCase <NSObject>

/// Evaluate \c object and return a value.
///
/// Note that this differs from e.g. \c NSPredicate in that the object return value is not a boolean, but an object representing the result of some computation.
///
/// \param object  The object to evaluate.
/// \return        The value of the case if it matches \c object, or else nil. The returned value is implementation-defined, but is often the return value of a block which is called when the case’s predicate matches \c object.
-(id)evaluateWithObject:(id)object;

@end


/// An object which can match or discard objects.
@protocol HMRPredicate <NSObject>

/// Attempt a (potentially structurally recursive) comparison against \c object.
///
/// \param object  The object to attempt to match.
/// \return        \c YES if \c object was matched, \c NO otherwise.
-(bool)matchObject:(id)object;

/// Produce a case which will evaluate a block when the receiver matches an object.
///
/// \param block  A block to evaluate for successful matches. Must not be nil. If the predicate does not bind any arguments using \c HMRBind(), then no arguments will be passed; otherwise, every object matched by \c HMRBind() in the predicate will be passed as an individual argument to the block.
/// \return       A \c id<HMRCase> instance which will evaluate \c block when it is evaluated with an object which the receiver is able to match.
-(id<HMRCase>)then:(id (^)())block;

@end


/// Match \c subject against a series of \c cases.
///
/// \param subject  The object to match.
/// \param cases    The cases to match against.
/// \return         The result of calling -evaluateWithObject: on each element of \c cases in order until one matches (evaluates to non-nil), or nil if none of them evaluate. Note that the cases may return nil, in which case evaluation will continue on to the next case. If this is not the intended behaviour, use some other arbitrary sigil value instead of nil, e.g. \c +[NSNull null].
id HMRMatch(id subject, NSArray *cases);


/// Returns a predicate which binds any object it is matched against, making it available to its case’s block as an argument.
///
/// The returned object is also a combinator, so that it can be used when using combinators as predicates to match combinators, e.g. using \c HMRAnd(HMRBind(), HMRBind()) to destructure a concatenation. It is not useful for parsing, however, only for destructuring pattern matching.
id HMRBind(void);

/// Returns a predicate which matches (but does not bind) all objects.
id HMRAny(void);
