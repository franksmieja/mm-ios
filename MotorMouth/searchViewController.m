//
//  searchViewController.m
//  MotorMouth
//
//  Created by kavi yadav on 24/01/18.
//  Copyright © 2018 Pushpendra. All rights reserved.
//

#import "searchViewController.h"
#import "AppBaseViewController.h"
#import "InternetUtilClass.h"
#import "ProgressHUD.h"


#define Main_Url       @"https://test.motormouth.club/"
@interface searchViewController ()<UIWebViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@end

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _txtSearch.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;

}
-(void)loadRequest:(NSURLRequest *)requestObj{
    if (![[InternetUtilClass sharedInstance] hasConnectivity]) {
        NSLog(@"Please check internet connectivity");
        [AppBaseViewController showAlertMessageWithTitle:@"No Internet connection" message:@"" delegate:self parentViewController:self];
    }
    else{
        
        [self.webView loadRequest:requestObj];
    }
}
#pragma Text fields Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (![_txtSearch.text isEqualToString:@""]) {
        [_txtSearch resignFirstResponder];
        [ProgressHUD show:@"Loading..." Interaction:NO];

        NSString*searchUrlstring = [NSString stringWithFormat:@"%@?s=%@&query=mobileApp",Main_Url,_txtSearch.text];
        NSURL *url = [NSURL URLWithString:searchUrlstring];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self loadRequest:requestObj];
    }

    return YES;
}

- (IBAction)tapOnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (IBAction)tapOnsearch:(id)sender {
    if (![_txtSearch.text isEqualToString:@""]) {
        [_txtSearch resignFirstResponder];
        [ProgressHUD show:@"Loading..." Interaction:NO];

        NSString*searchUrlstring = [NSString stringWithFormat:@"%@?s=%@&query=mobileApp",Main_Url,_txtSearch.text];
        NSURL *url = [NSURL URLWithString:searchUrlstring];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self loadRequest:requestObj];
    }
}

#pragma webView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *currentURL = webView.request.URL.absoluteString;
        [ProgressHUD dismiss];
}

@end
