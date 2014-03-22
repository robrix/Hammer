//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRCombinator.h>

extern NSSet *HMRParseCollection(id<HMRCombinator> parser, id<NSFastEnumeration> collection);
extern id<HMRCombinator> HMRParseElement(id<HMRCombinator> parser, id element);

@interface HMRParserCombinator : NSObject <HMRCombinator>
@end
