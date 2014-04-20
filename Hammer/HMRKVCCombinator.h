//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Hammer/Hammer.h>

@interface HMRKVCCombinator : HMRCombinator

+(instancetype)keyPath:(NSString *)keyPath combinator:(HMRCombinator *)combinator;

@property (readonly) NSString *keyPath;
@property (readonly) HMRCombinator *combinator;


+(instancetype)new UNAVAILABLE_ATTRIBUTE;
-(instancetype)init UNAVAILABLE_ATTRIBUTE;

@end
