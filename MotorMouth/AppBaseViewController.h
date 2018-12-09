//
//  AppBaseViewController.h
//  MotorMouth
//
//  Created by Pushpendra on 11/10/17.
//  Copyright © 2017 Pushpendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppBaseViewController : UIViewController

@property(nonatomic, assign) UIColor *colorPrimary;
@property(nonatomic, assign) UIColor *colorDark;
@property(nonatomic, assign) UIColor *colorAccent;

+(BOOL) doesAlertViewExist;
+(void) showAlertMessageWithTitle:(NSString *) title message :(NSString *)msg  delegate:(id)del parentViewController:(UIViewController *)parentVC;
@end
