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
	id<HMRCombinator> alternatives = HMRAlternate(HMRDelay(HMRConcatenate(HMRDelay(HMRLiteral(@"f")), HMRDelay(HMRConcatenate(HMRDelay(HMRLiteral(@"o")), HMRDelay(HMRConcatenate(HMRDelay(HMRLiteral(@"o")), HMRDelay(HMRLiteral(@"t")))))))), HMRDelay(HMRConcatenate(HMRDelay(HMRLiteral(@"f")), HMRDelay(HMRConcatenate(HMRDelay(HMRLiteral(@"o")), HMRDelay(HMRConcatenate(HMRDelay(HMRLiteral(@"o")), HMRDelay(HMRLiteral(@"d")))))))));
	id<HMRCombinator> derivative = [[[alternatives derivative:@"f"].compaction derivative:@"o"].compaction derivative:@"o"].compaction;
	///Users/rob/Developer/Projects/Hammer/Hammer/HMRLexer.m:25: error: -[null_reduction_of_partially_parsed_strings derivative_should_equal_null_] : derivative ((∅ ∘ ('o' ∘ ('o' ∘ 't')) | ('o' ∘ ('o' ∘ 'd'))) | (∅ ∘ (ε↓{'o'} ∘ ('o' ∘ 't')) | (ε↓{'o'} ∘ ('o' ∘ 'd'))) | (ε↓{'f'} ∘ (∅ ∘ ('o' ∘ 't')) | (ε↓{'o'} ∘ (ε↓{'o'} ∘ 't')) | (∅ ∘ ('o' ∘ 'd')) | (ε↓{'o'} ∘ (ε↓{'o'} ∘ 'd')))) does not equal (null)

	
//	id<HMRCombinator> derivative2 = HMRAlternate(HMRConcatenate(HMRCaptureTree(@"f"), HMRConcatenate(HMRCaptureTree(@"o"), HMRConcatenate(HMRCaptureTree(@"o"), HMRCaptureTree(@"t")))), HMRConcatenate(HMRCaptureTree(@"f"), HMRConcatenate(HMRCaptureTree(@"o"), HMRConcatenate(HMRCaptureTree(@"o"), HMRCaptureTree(@"d")))));
	
	// put laziness in reduction, repetition, alternation, and concatenation instead
	
	l3_expect(derivative).to.equal(nil);
}
