//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRPredicateCombinator.h"

@interface HMRKindOf : HMRPredicateCombinator

/// Constructs a kind-of combinator.
///
/// \param targetClass  The class to compare input against. Must not be nil.
/// \return             A combinator which matches objects whose which respond YES to \c -isKindOfClass: when passed \c class.
+(instancetype)kindOfClass:(Class)targetClass;

@property (readonly) Class targetClass;


-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
