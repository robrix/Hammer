//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmptyParser.h"
#import "HMRNullReductionParser.h"

@implementation HMRNullReductionParser

+(instancetype)parserWithElement:(id)element {
	NSParameterAssert(element != nil);
	
	return [[self alloc] initWithParseForest:[NSSet setWithObject:element]];
}

-(instancetype)initWithParseForest:(NSSet *)parseForest {
	if ((self = [super init])) {
		_parseForest = [parseForest copy];
	}
	return self;
}


#pragma mark HMRParser

-(HMRParser *)derivativeWithRespectToElement:(id)element {
	return [HMREmptyParser parser];
}

@end
