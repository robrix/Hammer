//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRCombinator.h>
#import <Reducers/REDReducible.h>

extern NSSet *HMRParseCollection(id<HMRCombinator> parser, id<REDReducible> reducible);
extern id<HMRCombinator> HMRParseObject(id<HMRCombinator> parser, id<NSObject, NSCopying> object);

@interface HMRParserCombinator : NSObject <HMRCombinator>

-(id<HMRCombinator>)deriveWithRespectToObject:(id<NSObject, NSCopying>)object;

-(NSSet *)reduceParseForest;

/// Produce a deeply compacted representation of the receiver.
-(id<HMRCombinator>)compact;

-(NSString *)describe;

@end
