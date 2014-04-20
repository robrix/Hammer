//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import <Foundation/Foundation.h>

@protocol HMRKeyValueCoding <NSObject>

-(id)valueForKeyPath:(NSString *)keyPath;

@end
