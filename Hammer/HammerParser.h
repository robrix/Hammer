//  HammerParser.h
//  Created by Rob Rix on 12-06-24.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface HammerParser : NSObject

@property (nonatomic, copy) NSDictionary *patterns;

-(BOOL)parse:(id)sequence error:(NSError **)error;

@end
