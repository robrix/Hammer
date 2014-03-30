//  Copyright (c) 2014 Rob Rix. All rights reserved.

#import "HMRLexer.h"

/*
 depth-first problem solving
 
 match a series of regular patterns like so:
 
 word = [A-Za-z]+ -> produce token
 whitespace = [ \s\t\n\r]+
 
 start = (word | whitespace)+
 
 while computing this, when we determine that we have produced a word, then perform its reduction
 */
l3_test("null reduction of partially parsed strings") {
	id<HMRCombinator> alternatives = HMRAlternate(HMRConcatenate(HMRLiteral(@"f"), HMRConcatenate(HMRLiteral(@"o"), HMRConcatenate(HMRLiteral(@"o"), HMRLiteral(@"t")))), HMRConcatenate(HMRLiteral(@"f"), HMRConcatenate(HMRLiteral(@"o"), HMRConcatenate(HMRLiteral(@"o"), HMRLiteral(@"t")))));
	id<HMRCombinator> derivative = [[[alternatives derivative:@"f"] derivative:@"o"] derivative:@"o"].compaction;
	l3_expect(derivative).to.equal(nil);
}
