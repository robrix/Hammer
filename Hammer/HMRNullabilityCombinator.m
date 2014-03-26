//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMREmpty.h"
#import "HMRNullabilityCombinator.h"

@implementation HMRNullabilityCombinator

+(instancetype)combinatorWithParser:(id<HMRCombinator>)parser {
	return [[self alloc] initWithParser:parser];
}

-(instancetype)initWithParser:(id<HMRCombinator>)parser {
	if ((self = [super init])) {
		_parser = [parser copyWithZone:NULL];
	}
	return self;
}


#pragma mark HMRCombinator

-(id<HMRCombinator>)derivativeWithRespectToElement:(id)element {
	return [HMREmpty parser];
}


-(NSSet *)reduceParseForest {
	return self.parser.parseForest;
}


-(NSString *)describe {
	return [NSString stringWithFormat:@"δ(%@)", self.parser.description];
}

@end
