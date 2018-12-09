//
//  NSString+Utility.h
//  WishAMitr
//
//  Created by Pradeep parmar on 22/07/16.
//  Copyright © 2016 AppWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)
/**
 Remove White space from the String.
 **/
-(NSString *)removeWhiteSpaces;

/**
 Check weather a string is empty or not.
 **/
-(BOOL) isEmptyString;

/**
 Check Weahter a url is Valid or not.
 **/
- (BOOL) isValidUrl;

/**
 Check Weahter a email is Valid or not.
 **/
-(BOOL)isValidEmail;

/**
 Get substring from the Left Side.
 **/
-(NSString *)left:(NSInteger) charNumber;

/**
 Get substring from the Right Side.
 **/
-(NSString *)right:(NSInteger) charNumber;

/**
 Get Only digits (0-9) from the String.
 **/
-(NSString *) getOnlyDigits;
@end
