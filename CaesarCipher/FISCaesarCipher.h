//
//  FISCaesarCipher.h
//  CaesarCipher
//
//  Created by Chris Gonzales on 5/29/14.
//  Copyright (c) 2014 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISCaesarCipher : NSObject
//declare methods here

- (NSString *)encodeMessage:(NSString *)message withOffset:(NSInteger)key;
- (NSString *)decodeMessage:(NSString *)encodedMessage withOffset:(NSInteger)key;

@end
