//
//  LoginViewController.m
//  MotorMouth
//
//  Created by Pushpendra on 11/10/17.
//  Copyright © 2017 Pushpendra. All rights reserved.
//

#import "LoginViewController.h"
#import "WebViewController.h"
#import "NSString+Utility.h"
#import "ProgressHUD.h"
#import "InternetUtilClass.h"

@interface LoginViewController ()<UIWebViewDelegate>{
    UITextField *currentTextField;
}

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnGetStarted;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUpCross;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    self.txtUserName.text = @"franktest";
//    self.txtPassword.text = @"franktestingaccount34";
    
    if([self.isWrongCredential isEqualToString:@"yes"]){
        [AppBaseViewController showAlertMessageWithTitle:@"No Internet connection" message:@"" delegate:self parentViewController:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deregisterFromKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Notification
// For textfeld move up if it hide on keyboard

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    // scroll to the text view
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible.
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    self.scrollView.scrollEnabled = YES;
    if (!CGRectContainsPoint(aRect, currentTextField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:currentTextField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    // scroll back..
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    self.scrollView.scrollEnabled = NO;
}

// Tap on GetStarted Button
-(BOOL)isValidInputs{
    BOOL isValid = true;
    self.txtUserName.text = [self.txtUserName.text removeWhiteSpaces];
    self.txtPassword.text = [self.txtPassword.text removeWhiteSpaces];
    
    if ([self.txtUserName.text isEmptyString]) {
        isValid = false;
        [AppBaseViewController showAlertMessageWithTitle: @"Error"
                                                 message: @"Please enter User Name"
                                                delegate: nil
                                    parentViewController: self];
    }
    
    else if ([self.txtPassword.text isEmptyString]) {
        isValid = false;
        [AppBaseViewController showAlertMessageWithTitle: @"Error"
                                                 message: @"Please enter password"
                                                delegate: nil
                                    parentViewController: self];
    }
    return isValid;
}


- (IBAction)tapOnLogin:(id)sender {
    if ([self isValidInputs]){
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setValue:self.txtUserName.text forKey:@"userName"];
        [userDict setValue:self.txtPassword.text forKey:@"password"];
   //     [self performSegueWithIdentifier:@"segueWebView" sender:userDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedIn" object:nil userInfo:userDict];
       // [self.delegate getLoginInfo:userDict];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (IBAction)tapOnRegister:(id)sender {
    if (![[InternetUtilClass sharedInstance] hasConnectivity]) {
        [AppBaseViewController showAlertMessageWithTitle:@"No Internet connection" message:@"" delegate:self parentViewController:self];        
    }
    else{
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setValue:@"" forKey:@"userName"];
        [userDict setValue:@"" forKey:@"password"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedIn" object:nil userInfo:userDict];

        //[self.delegate getLoginInfo:userDict];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        [ProgressHUD dismiss];
    }else{
        //reset clicked
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
        NSString *currentURL = webView.request.URL.absoluteString;
        
        NSLog(@"Webview url : %@",currentURL);
        NSLog(@"Webview Response : %@",[webView stringByEvaluatingJavaScriptFromString:@"document.body.textContent"]);
        
        // for login (Auto login)
        if ([currentURL isEqualToString:@"http://motormouth.wearezipline.com/"]) {
            
        }
        else if ([currentURL isEqualToString:@"http://motormouth.wearezipline.com/login/?redirect_to"]) {
            [self.webView removeFromSuperview];
        }
        if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
            // UIWebView object has fully loaded.
            [ProgressHUD dismiss];
        }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [ProgressHUD show:@"Loading..." Interaction:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [ProgressHUD dismiss];
}

#pragma mark - UITextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField == self.txtUserName) {
        [self.txtPassword becomeFirstResponder];
    }
    else if (textField == self.txtPassword){
        [self.txtPassword resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currentTextField = nil;
}

#pragma mark - UITextField Toolbar Buttons Methods
-(void)cancelButtonClicked:(id)sender{
    if ([currentTextField isFirstResponder]) {
        [currentTextField resignFirstResponder];
    }
    currentTextField = nil;
}

-(void)doneButtonClicked:(id)sender{
    if ([currentTextField isFirstResponder]) {
        [currentTextField resignFirstResponder];
    }
    currentTextField = nil;
}
- (IBAction)tapOncross:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)tapOnHideSignUp{
    [self.webView removeFromSuperview];
}

@end
