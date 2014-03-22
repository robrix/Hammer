//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmptyParser.h"
#import "HMRNullabilityParser.h"

@implementation HMRNullabilityParser

+(instancetype)parserWithParser:(HMRParser *)parser {
	return [[self alloc] initWithParser:parser];
}

-(instancetype)initWithParser:(HMRParser *)parser {
	if ((self = [super init])) {
		_parser = [parser copy];
	}
	return self;
}


#pragma mark HMRCombinator

-(HMRParser *)derivativeWithRespectToElement:(id)element {
	return [HMREmptyParser parser];
}


-(NSSet *)deforest {
	return [self.parser deforest];
}

@end
