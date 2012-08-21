//  HammerNullReductionParser.m
//  Created by Rob Rix on 2012-07-28.
//  Copyright (c) 2012 Monochrome Industries. All rights reserved.

#import "HammerEmptyParser.h"
#import "HammerNullReductionParser.h"

@implementation HammerNullReductionParser {
	NSSet *_trees;
}

+(instancetype)parserWithParseTrees:(NSSet *)trees {
	HammerNullReductionParser *parser = [self new];
	parser->_trees = trees;
	return parser;
}


@synthesize trees = _trees;


-(HammerParser *)parse:(id)object {
	return [HammerEmptyParser parser];
}

-(NSSet *)parseNull {
	return _trees;
}


-(BOOL)canParseNull {
	return YES;
}

@end
