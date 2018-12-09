//
//  NSDate+Utility.m
//  WishAMitr
//
//  Created by Pradeep parmar on 26/07/16.
//  Copyright © 2016 AppWorks. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility) 

-(NSString *) stringValueWithFormat:(NSString *)format {
    // change to a readable time format and change to local time zone
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timeStamp = [dateFormatter stringFromDate:self];
    
    return timeStamp;
}

-(NSDate *) toLocalTime{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [timeZone secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}


-(NSDate *) toGlobalTime{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[timeZone secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

-(BOOL) isGreaterThanDate:(NSDate *) dateToCompare {
    BOOL isGreater = false;
    
    //Compare Values
    if ([self compare:dateToCompare] == NSOrderedDescending) {
        isGreater = true;
    }
    return isGreater;
}

-(BOOL) isLessThanDate:(NSDate *) dateToCompare {
    BOOL isLess = false;
    
    //Compare Values
    if ([self compare:dateToCompare] == NSOrderedAscending) {
        isLess = true;
    }
    return isLess;
}

-(BOOL) equalToDate:(NSDate *) dateToCompare {
    BOOL isEqualTo = false;
    
    //Compare Values
    if ([self compare:dateToCompare] == NSOrderedSame) {
        isEqualTo = true;
    }
    return isEqualTo;
}

-(BOOL) isLessThanOrEqualToDate:(NSDate *) dateToCompare {
    return ([self isLessThanDate:dateToCompare ] || [self isEqualToDate:dateToCompare]);
}

-(BOOL) isGreaterThanOrEqualToDate:(NSDate *) dateToCompare {
    return ([self isGreaterThanDate:dateToCompare ] || [self isEqualToDate:dateToCompare]);
}

-(NSDate *) addDays:(int)days  {
    //NSLog(@"Old date : %@",self);
    
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:days toDate:self options:0];
    // NSLog(@"After Added days : %d new date : %@", days, newDate);
    return (newDate);
}
@end
