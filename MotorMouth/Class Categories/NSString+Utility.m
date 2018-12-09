//
//  NSString+Utility.m
//  WishAMitr
//
//  Created by Pradeep parmar on 22/07/16.
//  Copyright © 2016 AppWorks. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility) 

-(NSString *)removeWhiteSpaces{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(BOOL) isEmptyString{
    if (self == nil) {
        return true;
    }
    
    BOOL isEmpty = false;
    NSString *trimmedString = [self removeWhiteSpaces];
    if (trimmedString.length <= 0 ) {
        isEmpty = true;
    }
    return isEmpty;
}

- (BOOL) isValidUrl {
    BOOL isValid = false;
    BOOL isEmpty = [self isEmptyString];
    if (!isEmpty) {
        //        NSString *urlRegEx =
        //        @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
        NSString *urlRegEx = @"^(http(s)?://)?((www)?\\.)?[\\w]+\\.[\\w]+";
        NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
        isValid = [urlTest evaluateWithObject:self];
    }
    return isValid;
}

-(BOOL)isValidEmail {
//    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
//    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
//    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
//    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

-(NSString *)left:(NSInteger) charNumber{
    return [self substringWithRange:NSMakeRange(0, charNumber)];
}


-(NSString *)right:(NSInteger) charNumber{
    return [self substringWithRange:NSMakeRange([self length]- charNumber, charNumber)];
}

-(NSString *) getOnlyDigits{
    return  [self stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self length])];
}
@end
