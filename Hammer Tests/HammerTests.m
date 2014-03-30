//  Copyright (c) 2014 Rob Rix. All rights reserved.

//  This is a stub to give the test target something to compile. The tests occur inline.
@interface HammerTests : XCTestCase
@end

@implementation HammerTests

+(id)defaultTestSuite {
	return [L3TestSuite suiteForExecutablePath:@L3_BUNDLE_LOADER];
}

@end
