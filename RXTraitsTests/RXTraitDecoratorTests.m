//  RXTraitDecoratorTests.m
//  Created by Rob Rix on 12-07-01.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import <SenTestingKit/SenTestingKit.h>
#import "RXTrait.h"

@protocol RXPoint2D <NSObject>

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end

@protocol RXPoint3D <RXPoint2D>

@property (nonatomic, assign) CGFloat z;

@end


@interface RXPoint2D : NSObject <RXPoint2D>
@end

@implementation RXPoint2D
@synthesize x, y;
@end


@interface RXPoint3D : NSObject <RXPoint3D>
@end

@implementation RXPoint3D
@synthesize x, y, z;
@end


@interface RXZClampedPoint3DTrait : NSObject <RXTrait, RXPoint3D>
@end

@implementation RXZClampedPoint3DTrait

+(Protocol *)traitProtocol {
	return @protocol(RXPoint3D);
}

+(Protocol *)targetProtocol {
	return @protocol(RXPoint2D);
}

@dynamic x, y;

-(CGFloat)z {
	return 0;
}

-(void)setZ:(CGFloat)z {}

@end


@interface RXTraitDecoratorTests : SenTestCase
@end

@implementation RXTraitDecoratorTests

-(void)testDoesNotOverrideImplementedMethods {
	id<RXPoint3D> point3D = RXTraitApply([RXZClampedPoint3DTrait class], [RXPoint2D new]);
	STAssertEquals(point3D.x, 0., @"Expected to equal.");
	point3D.x = M_PI;
	STAssertEquals(point3D.x, M_PI, @"Expected to equal.");
	
	point3D = RXTraitApply([RXZClampedPoint3DTrait class], [RXPoint3D new]);
	STAssertEquals(point3D.z, 0., @"Expected to equal.");
	point3D.z = M_PI;
	STAssertEquals(point3D.z, M_PI, @"Expected to equal.");
}

-(void)testAddsTraitMethods {
	id<RXPoint3D> point3D = RXTraitApply([RXZClampedPoint3DTrait class], [RXPoint2D new]);
	STAssertEquals(point3D.z, 0., @"Expected to equal.");
	point3D.z = M_PI;
	STAssertEquals(point3D.z, 0., @"Expected to equal.");
}

@end
