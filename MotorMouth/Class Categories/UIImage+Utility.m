//
//  UIImage+Utility.m
//  WishAMitr
//
//  Created by Pradeep parmar on 29/07/16.
//  Copyright © 2016 AppWorks. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

//Method to resize image with given width and height.
-(UIImage*)resizeImageWithSize:(CGSize)size
{
    //CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
