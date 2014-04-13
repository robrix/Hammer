//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRCombinator.h>

/// Calculates the size of \c combinator.
///
/// This size is defined as the recursive count of all combinators in the grammar rooted at \c combinator. All terminals have a size of 1, whereas all nonterminals have a size of 1 + the number of sub-combinators they contain. Delayed combinators calculate their size as though they were not delayed, i.e. the delays in e.g. cyclic grammars do not contribute to the computed size.
///
/// \param combinator  The combinator to calculate the size of.
/// \return            An unsigned integer representing the size of \c combinator.
NSUInteger HMRCombinatorSize(id<HMRCombinator> combinator);


/// Pretty-prints a grammar starting with \c combinator.
NSString *HMRPrettyPrint(id<HMRCombinator> combinator);