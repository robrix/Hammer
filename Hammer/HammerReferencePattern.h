//  HammerReferencePattern.h
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Hammer/HammerPattern.h>

typedef id<HammerPattern> (^HammerLazyPattern)();

@interface HammerReferencePattern : NSObject <HammerPattern>

+(instancetype)patternWithPattern:(id<HammerPattern>)pattern;
+(instancetype)patternWithLazyPattern:(HammerLazyPattern)pattern;

@property (nonatomic, readonly) id<HammerPattern> pattern;

@end
