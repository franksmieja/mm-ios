//
//  NSDate+Utility.h
//  WishAMitr
//
//  Created by Pradeep parmar on 26/07/16.
//  Copyright © 2016 AppWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

/**
 Return the NSDate into string with specified date format.
 **/
-(NSString *) stringValueWithFormat:(NSString *)format;

/**
 Return NSDate into localTime zone.
 **/
-(NSDate *) toLocalTime;

/**
 Return NSDate into Gobal Time zone.
 **/
-(NSDate *) toGlobalTime;

/**
 Compare two dates and return true if current date is greater then from another date.
 **/
-(BOOL) isGreaterThanDate:(NSDate *) dateToCompare;

/**
 Compare two dates and return ture if current date is less then from another date.
 **/
-(BOOL) isLessThanDate:(NSDate *) dateToCompare;

/**
 Compare two dates and return ture if current date is euqal to another date.
 **/
-(BOOL) equalToDate:(NSDate *) dateToCompare ;

/**
 Compare two dates and return ture if current date is lessThenOrEqual to another date.
 **/
-(BOOL) isLessThanOrEqualToDate:(NSDate *) dateToCompare ;

/**
 Compare two dates and return ture if current date is greateThenOrEqual to another date.
 **/
-(BOOL) isGreaterThanOrEqualToDate:(NSDate *) dateToCompare;

/**
 Add number of days into NSDate.
 **/
-(NSDate *) addDays:(int)days;
@end
