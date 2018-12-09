//
//  LoginViewController.h
//  MotorMouth
//
//  Created by Pushpendra on 11/10/17.
//  Copyright © 2017 Pushpendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppBaseViewController.h"

@protocol LoginViewDelegate

-(void)getLoginInfo:(NSDictionary *)userDict;

@end


@interface LoginViewController : AppBaseViewController
@property(nonatomic, strong) NSString *isWrongCredential;
@property(nonatomic, weak) id delegate;

- (IBAction)tapOnLogin:(id)sender;

@end
