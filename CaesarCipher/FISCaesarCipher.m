//
//  FISCaesarCipher.m
//  CaesarCipher
//
//  Created by Chris Gonzales on 5/29/14.
//  Copyright (c) 2014 FIS. All rights reserved.
//

#import "FISCaesarCipher.h"

@implementation FISCaesarCipher
//define methods here

- (NSString *)encodeMessage:(NSString *)message withOffset:(NSInteger)key
{
	NSMutableString *encodedString = [[NSMutableString alloc] init];
	
	for (NSUInteger i = 0; i < message.length; i++) {
		// get the substring at index i
		NSString *substring = [message substringWithRange:NSMakeRange(i, 1)];
		
		// Encode the substring
		NSString *encodedSubstring = [self _shiftSingleLetter:substring withOffset:key];
		
		// Putting the string back together
		[encodedString appendString:encodedSubstring];
	}
	
	return encodedString;
}

- (NSString *)decodeMessage:(NSString *)encodedMessage withOffset:(NSInteger)key
{
	NSMutableString *decodedString = [[NSMutableString alloc] init];
	
	// Flip the key for decode
	key = -key;
	
	for (NSUInteger i = 0; i < encodedMessage.length; i++) {
		// get the substring at index i
		NSString *substring = [encodedMessage substringWithRange:NSMakeRange(i, 1)];
		
		// Encode the substring
		NSString *encodedSubstring = [self _shiftSingleLetter:substring withOffset:key];
		
		// Putting the string back together
		[decodedString appendString:encodedSubstring];
	}
	
	return decodedString;
}

/*
 Shifts a single letter according to the key
 
 Uppercase A through Z is represented in decimal as 65 through 90
 Lowercase a through z is represented in decimal as 97 through 122
 
 This will adhere to the following rules:
 
 1. Case is preserved
 2. Anything that is not a letter in the alphabet, such as a spaces and punctuation, will just return the letter unchanged
 3. The offset can be nearly and integer, so the method has to wrap around from Z -> A
 */
- (NSString *)_shiftSingleLetter:(NSString *)letter withOffset:(NSInteger)key
{
	
	// get the unichar representation of the letter
	unichar unicharLetter = [letter characterAtIndex:0];
	
	// Making sure this is a letter we want to shift
	if (![self _isLetter:unicharLetter]) {
		return letter;
	}
	
	unichar shiftedLetter = unicharLetter;
	
	if ([self _isUpperCase:unicharLetter]) {
		// The letter is uppercase
		shiftedLetter = [self _shiftLetter:unicharLetter byOffset:key withFloor:65 ceiling:90];
	}
	else {
		// The letter is lowercase
		shiftedLetter = [self _shiftLetter:unicharLetter byOffset:key withFloor:97 ceiling:122];
	}

	return [NSString stringWithFormat:@"%C", shiftedLetter];
}

/**
 Shifts a single unichar by the specified offset within the bounds specified by the floor and ceiling
 */
- (unichar)_shiftLetter:(unichar)letter byOffset:(NSInteger)offset withFloor:(NSInteger)floor ceiling:(NSInteger)ceiling
{
	 unichar shiftedLetter = letter;
	if (offset > 0) {
		// Right shift
		shiftedLetter = [self _rightShift:letter byOffset:offset withFloor:floor ceiling:ceiling];
	}
	else if (offset < 0) {
		// Left shift
		shiftedLetter = [self _leftShift:letter byOffset:offset withFloor:floor ceiling:ceiling];
	}
	
	return shiftedLetter;
}

/**
 Shifts the specified letter one place to the right, wrapping if necessary
 */
- (unichar)_rightShift:(unichar)letter byOffset:(NSInteger)offset withFloor:(NSInteger)floor ceiling:(NSInteger)ceiling
{
	for (NSUInteger numberOfShifts = 0; numberOfShifts < offset; numberOfShifts++) {
		
		// Check for wrapping
		if ((letter + 1) > ceiling) {
			letter = floor;
		}
		else {
			// Increment letter to the right by 1
			letter += 1;
		}
	}
	return letter;
}

/**
 Shifts the specified letter one place to the left, wrapping if necessary
 LeftShifts have a negative offset
 */
- (unichar)_leftShift:(unichar)letter byOffset:(NSInteger)offset withFloor:(NSInteger)floor ceiling:(NSInteger)ceiling
{
	// Taking the absolute value of the left shifted offset because left shifts are negative
	NSInteger absoluteOffset = labs(offset);
	
	for (NSUInteger numberOfShifts = 0; numberOfShifts < absoluteOffset; numberOfShifts++) {
		
		// Check for wrapping
		if ((letter - 1) < floor) {
			letter = ceiling;
		}
		else {
			letter -= 1;
		}
	}
	
	return letter;
}

- (BOOL)_isLetter:(unichar)maybeLetter
{
	if ((maybeLetter >= 65 && maybeLetter <= 90) ||
			(maybeLetter >= 97 && maybeLetter <= 122)) {
		return YES;
	}
	return NO;
}

- (BOOL)_isUpperCase:(unichar)letter
{
	if (letter >= 65 && letter <= 90) {
		return YES;
	}
	return NO;
}

@end
