//
//  AppBaseViewController.m
//  MotorMouth
//
//  Created by Pushpendra on 11/10/17.
//  Copyright © 2017 Pushpendra. All rights reserved.
//

#import "AppBaseViewController.h"
#import "ProgressHUD.h"

@interface AppBaseViewController ()

@end

@implementation AppBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    *colorPrimary, *colorDark, *colorAccent
    
    self.colorPrimary = [UIColor colorWithRed:17/255.0 green:58/255.0 blue:73/255.0 alpha:1];
    self.colorDark = [UIColor colorWithRed:41/255.0 green:72/255.0 blue:91/255.0 alpha:1];
    self.colorAccent = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(BOOL) doesAlertViewExist {
    if ([[UIApplication sharedApplication].keyWindow isMemberOfClass:[UIWindow class]])
    {
        return NO;//AlertView does not exist on current window
    }
    return YES;//AlertView exist on current window
}


+(void) showAlertMessageWithTitle:(NSString *) title message :(NSString *)msg  delegate:(id)del parentViewController:(UIViewController *)parentVC {
    if (![self doesAlertViewExist]) {
        if([UIAlertController class] == nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:msg
                                                           delegate:del
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                     message:msg
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            //We add buttons to the alert controller by creating UIAlertActions:
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           [ProgressHUD dismiss];
                                           
                                       }];//You can use a block here to handle a press on this button
            [alertController addAction:actionOk];
            [parentVC presentViewController:alertController animated:YES completion:nil];
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
