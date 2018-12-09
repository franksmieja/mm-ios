//
//  WebViewController.h
//  MotorMouth
//
//  Created by Pushpendra on 11/10/17.
//  Copyright © 2017 Pushpendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface WebViewController : AppBaseViewController<UIWebViewDelegate, CAAnimationDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, LoginViewDelegate>

@end
