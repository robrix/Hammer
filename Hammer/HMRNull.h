//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/HMRTerminal.h>

@interface HMRNull : HMRTerminal

+(instancetype)captureForest:(NSSet *)forest;

@property (readonly) NSSet *parseForest;

-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
