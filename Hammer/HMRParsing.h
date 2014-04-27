//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRCombinator.h>
#import <Reducers/REDReducible.h>

NSSet *HMRParseCollection(HMRCombinator *parser, id<REDReducible> reducible);
HMRCombinator *HMRParseObject(HMRCombinator *parser, id<NSObject, NSCopying> object);


HMRCombinator *HMRParser(void);
