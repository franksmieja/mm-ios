//
//  NSDictionary+Utility.m
//  WishAMitr
//
//  Created by Pradeep parmar on 27/07/16.
//  Copyright © 2016 AppWorks. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)
- (BOOL)containsKey: (NSString *)key {
    BOOL retVal = 0;
    NSArray *allKeys = [self allKeys];
    retVal = [allKeys containsObject:key];
    return retVal;
}
@end
