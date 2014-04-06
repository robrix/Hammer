//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRCombinator.h>
#import <Reducers/REDReducible.h>

NSSet *HMRParseCollection(id<HMRCombinator> parser, id<REDReducible> reducible);
id<HMRCombinator> HMRParseObject(id<HMRCombinator> parser, id<NSObject, NSCopying> object);

NSString *HMRPrettyPrint(id<HMRCombinator> grammar);
