//
//  WebViewController.m
//  MotorMouth
//
//  Created by Pushpen  dra on 11/10/17.
//  Copyright © 2017 Pushpendra. All rights reserved.
//

#import "WebViewController.h"
#import "ProgressHUD.h"
#import "TabCollectionViewCell.h"
#import "LoginViewController.h"
#import "InternetUtilClass.h"
#import "NotificationViewController.h"
#import "MKNumberBadgeView.h"
#import "AppDelegate.h"
#define HIDE_HEADER_QUERY_STRING    @"?query=mobileApp"

@interface WebViewController ()<UIWebViewDelegate>{
    BOOL isMenuOpen, isFirstTimeLoad, isComeFromLogin, isBackActive;//isMmtvLoad, isTrandingLoad;
    NSString *stringslider, *previousUrl;
    NSDictionary *userInfo;
    NSString*UserNameFromJs ;
    MKNumberBadgeView *number;
    AppDelegate *appDelegate;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *blankImgView;

@property (strong, nonatomic) IBOutlet UILabel *counter;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *NotiFicationButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnMenuBar;

@property (nonatomic, strong) UIView *sliderView;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (nonatomic, strong) UITableView *tblMenu;
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraints;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalConstantWebView;

@property (strong, nonatomic) NSMutableArray *arrMenu;
@property (strong, nonatomic) NSMutableArray *arrTab;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *notificationBtnOutlet;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationButtonLeadingConst;

@end

@implementation WebViewController
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.arrMenu = [[NSMutableArray alloc] init];
    self.arrMenu = [self createMenu];
    self.arrTab = [[NSMutableArray alloc] init];
    [self createHomeTabAndTabUrl];
    userInfo = [[NSDictionary alloc] init];
    [self.view bringSubviewToFront:_navView];
    [self.btnMenu setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    isBackActive = NO;
    //Set Badge On Button
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"NavigationImage"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    //Counter
    self.counter.layer.cornerRadius = self.counter.frame.size.height/2;
    self.counter.layer.masksToBounds =YES;
    if (appDelegate.Notificationarray.count > 0) {
        self.counter.text =[NSString stringWithFormat:@"%lu",(unsigned long)appDelegate.Notificationarray.count];
        
    }else{
        self.counter.hidden = YES;
        
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(remoteNotificationHandler:) name:@"RemoteNotification" object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(getLoginInformation:) name:@"loggedIn" object:nil];
    
    //userName
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (!([[defaults objectForKey:@"UserNameFromJs"] length]== 0)) {
        UserNameFromJs = [defaults objectForKey:@"UserNameFromJs"];
    }
    
    
    NSString *fullURL;
    
    if ([[defaults objectForKey:@"userName"] length] == 0 && [[defaults objectForKey:@"password"] length] == 0){
        // fullURL = @"http://motormouth.wearezipline.com/";
        fullURL = @"https://test.motormouth.club/?query=mobileApp";
        _NotiFicationButton.hidden = true ;
        _notificationButtonLeadingConst.constant = 20 ;
        self.btnLogin.hidden = NO;
    }
    else{
        [ProgressHUD show:@"Loading..." Interaction:YES];
        fullURL = @"https://test.motormouth.club/login/?query=mobileApp";
        //        [ProgressHUD show:@"Loading" Interaction:NO];
        //        self.btnLogin.hidden = YES;
        
    }
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self loadRequest:requestObj];
    
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:_blankImgView];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    
    //MENU VIEW INITIALISE
    self.sliderView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width)+200, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"Slider view frame %f %f",self.sliderView.frame.size.width, self.sliderView.frame.size.width);
    self.sliderView.backgroundColor = [UIColor clearColor];
    
    // menu table view
    self.tblMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.sliderView.frame.size.width - 100, self.sliderView.frame.size.height)];
    [self.tblMenu registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tblMenu.delegate = self;
    self.tblMenu.dataSource = self;
    [self.tblMenu setBackgroundColor: [UIColor colorWithRed:17/255.0 green:58/255.0 blue:73/255.0 alpha:1]];
    self.tblMenu.bounces = NO;
    self.tblMenu.scrollEnabled = NO;
    self.tblMenu.scrollsToTop = YES;
    [self.tblMenu setSectionIndexColor:[UIColor whiteColor]];
    [self.tblMenu setSectionIndexBackgroundColor:[UIColor clearColor]];
    self.tblMenu.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tblMenu setSeparatorColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:0.1]];
    [self.sliderView addSubview:self.tblMenu];
    
    [self.view addSubview:self.sliderView];
    
    //    [ProgressHUD show:@"Loading..." Interaction:NO];
    NSArray *notificationArray =[[self appDelegate]fetchNotiFication];
    NSLog(@"%@",notificationArray);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadRequest:(NSURLRequest *)requestObj{
    if (![[InternetUtilClass sharedInstance] hasConnectivity]) {
        NSLog(@"Please check internet connectivity");
        [AppBaseViewController showAlertMessageWithTitle:@"No Internet connection" message:@"" delegate:self parentViewController:self];
        [ProgressHUD dismiss];
    }
    else{
        
        [self.webView loadRequest:requestObj];
    }
}

// Get info after login
-(void)getLoginInformation:(NSNotification *) notification {
    NSLog(@"%@",notification);
    userInfo = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    
    //userInfo = userDict;
    NSString *fullURL;
    
    if (![[userInfo valueForKey:@"userName"] isEqualToString:@""] && ![[userInfo valueForKey:@"password"] isEqualToString:@""]) {
        isComeFromLogin = YES;
        _NotiFicationButton.hidden = false ;
        _notificationButtonLeadingConst.constant = 50 ;
        
        fullURL = @"https://test.motormouth.club/login/?query=mobileApp";
        [self createHomeTabAndTabUrl];
        
    }
    else{
        [self hideTabBar];
        
        fullURL = @"https://test.motormouth.club/register/?query=mobileApp";
    }
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self loadRequest:requestObj];
    
}
// currently we are not using this method
-(void)getLoginInfo:(NSDictionary *)userDict{
    userInfo = userDict;
    NSString *fullURL;
    
    if (![[userDict valueForKey:@"userName"] isEqualToString:@""] && ![[userDict valueForKey:@"password"] isEqualToString:@""]) {
        isComeFromLogin = YES;
        fullURL = @"https://test.motormouth.club/login/?query=mobileApp";
    }
    else{
        [self hideTabBar];
        fullURL = @"https://test.motormouth.club/register/?query=mobileApp";
    }
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self loadRequest:requestObj];
}
// Move to login if user not logged in
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segue_feedback"]) {
        LoginViewController *loginVC = segue.destinationViewController;
        loginVC.delegate = self;
        loginVC.isWrongCredential = (NSString *)sender;
        
    }
    if ([segue.identifier isEqualToString:@"Notification"]) {
        NotificationViewController *NitificationVC = segue.destinationViewController;
        
    }
    
}

#pragma WEBVIEW DELEGATES
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *currentURL = webView.request.URL.absoluteString;
  //  webView.hidden = NO;

    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('header').style.display = 'none'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('front-page-header').style.display = 'none'"];
    
    
    NSLog(@"Webview url : %@",currentURL);
    NSLog(@"Webview Response : %@",[webView stringByEvaluatingJavaScriptFromString:@"document.body.textContent"]);
    
    // for login (Auto login)
    if ([currentURL isEqualToString:@"https://test.motormouth.club/login/?query=mobileApp"]) {
        //create js strings
        NSString *userName, *password;
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        if ([[data objectForKey:@"userName"] length] != 0 && [[data objectForKey:@"password"] length] != 0) {
            userName = [data objectForKey:@"userName"];
            password = [data objectForKey:@"password"];
        }
        else{
            userName = [userInfo valueForKey:@"userName"];
            password = [userInfo valueForKey:@"password"];
        }
        
        NSString *loadUsernameJS = [NSString stringWithFormat:@"var inputFields = document.querySelectorAll(\"input[type='text']\"); \
                                    for (var i = inputFields.length >>> 0; i--;) { inputFields[i].value = '%@';}", userName];
        
        NSString *loadPasswordJS = [NSString stringWithFormat:@"var inputFields = document.querySelectorAll(\"input[type='password']\"); \
                                    for (var i = inputFields.length >>> 0; i--;) { inputFields[i].value = '%@';}", password];
        
        //autofill the form
        [self.webView stringByEvaluatingJavaScriptFromString: loadUsernameJS];
        [self.webView stringByEvaluatingJavaScriptFromString: loadPasswordJS];
        
        NSString *jsStat = @"document.getElementsByName('loginform')[0].submit()";
        [self.webView stringByEvaluatingJavaScriptFromString:jsStat];
        
        UserNameFromJs = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('username').value"];
        NSLog(@"%@",UserNameFromJs);
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:UserNameFromJs forKey:@"UserNameFromJs"];
        
        //        [ProgressHUD dismiss];
    }
    
    else if ([currentURL isEqualToString:@"https://test.motormouth.club/?query=mobileApp"] && isComeFromLogin == NO) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:@"userName"] length] != 0 && [[defaults objectForKey:@"password"] length] != 0){
            self.btnLogin.hidden = YES;
            
        }
        else{
            self.btnLogin.hidden = NO;
        }
        UserNameFromJs = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('username').value"];
        NSLog(@"%@",UserNameFromJs);
        
        [defaults setObject:UserNameFromJs forKey:@"UserNameFromJs"];
        
        [self.view addSubview:self.webView];

    }
    else if ([currentURL isEqualToString:@"https://test.motormouth.club/?query=mobileApp"]&& isComeFromLogin == YES) {
        NSLog(@"Sucess");

        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:@"userName"] length] == 0 && [[defaults objectForKey:@"password"] length] == 0){
            [defaults setObject:[userInfo valueForKey:@"userName"]  forKey:@"userName"];
            [defaults setObject:[userInfo valueForKey:@"password"]  forKey:@"password"];
            [defaults synchronize];
            [self showTabBar];
        }
        [self.arrMenu removeAllObjects];
        self.arrMenu = [self createMenu];
        [self.tblMenu reloadData];
        
        self.btnLogin.hidden = YES;
        UserNameFromJs = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('username').value"];
        NSLog(@"%@",UserNameFromJs);
        
        [defaults setObject:UserNameFromJs forKey:@"UserNameFromJs"];
        
        
    }
    
    else if([currentURL isEqualToString:@"https://test.motormouth.club/login/?login=failed&query=mobileApp"]){
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        [self hideMenuView];
        [defaults removeObjectForKey:@"userName"];
        [defaults removeObjectForKey:@"password"];
        [defaults removeObjectForKey:@"UserNameFromJs"];
        
        [defaults synchronize];
        [self.tblMenu reloadData];
        
        isComeFromLogin = NO;
        
        [self createMenuUrl:@"" andUserName:@"" andUrlTag:@""];
        [self showTabBar];
        [self createHomeTabAndTabUrl];
        
        [self performSegueWithIdentifier:@"segueLogin" sender:@"yes"];
    }
    else if([currentURL isEqualToString:@"https://test.motormouth.club/register/?query=mobileApp"]){
        [self hideMenuView];
        self.btnLogin.hidden = NO;
    }
    
   // if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
        // UIWebView object has fully loaded.
        if ([currentURL isEqualToString:@"https://test.motormouth.club/login/?query=mobileApp"]){
            
        }else{
            [ProgressHUD dismiss];
        }
//}
    [self.view bringSubviewToFront:self.sliderView];
    webView.hidden = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString  *currentUrl = (NSString *)request.URL.absoluteString;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    if ([currentUrl containsString:@"groups/mine/?query=mobileApp"] ){
        if ([[defaults objectForKey:@"userName"] length] > 0){
            NSLog(@"%@",currentUrl);
            
        }else{
            [webView stopLoading];
            [self performSegueWithIdentifier:@"segueLogin" sender:nil];
            [self createMenuUrl:@"groups/" andUserName:@"" andUrlTag:@""];
            [self createGroupsTabAndTabUrl];
            [self showTabBar];
            [self.collectionView reloadData];
            
        }
    }
    else if ([currentUrl isEqualToString:@"https://test.motormouth.club/login/?query=mobileApp"]){
        NSLog(@"%@",currentUrl);
        _webView.hidden = YES;
    }
    else if ([currentUrl containsString:@"https://plus.google.com/up/?continue" ]){
        [webView stopLoading];
        [ProgressHUD dismiss];
        
    }
    else if ([currentUrl containsString:@"https://m.facebook.com/sharer.php" ]){
        [webView stopLoading];
        [ProgressHUD dismiss];

    }
    else if ([currentUrl containsString:@"https://twitter.com/intent/tweet" ]){
        [webView stopLoading];
        [ProgressHUD dismiss];

    }

   else if ([currentUrl containsString:@"http://www.facebook.com/sharer.php" ] || [currentUrl containsString:@"https://plus.google.com/share"] || [currentUrl containsString:@"https://twitter.com/share"]){
        [[UIApplication sharedApplication] openURL:[request URL]];

    }

    
    else if ([currentUrl containsString:@"wp-login.php"] || [currentUrl containsString:@"register"]){
        NSLog(@"%@",currentUrl);
        
    }
    else  if ([currentUrl containsString:@"https://test.motormouth.club"] && ([currentUrl containsString:@"&query=mobileApp"] ) ) {
        [ProgressHUD show:@"Loading..." Interaction:YES];
        // webView.hidden = YES;
        
        [self checkBackButton:currentUrl];
    }
    
    else  if ([currentUrl containsString:@"https://test.motormouth.club"] && ([currentUrl containsString:@"?query=mobileApp"] ) ) {
        [ProgressHUD show:@"Loading..." Interaction:YES];
        
        [self checkBackButton:currentUrl];

    }
    else if ([currentUrl containsString:@"whatsapp"] ){
        NSLog(@"%@",currentUrl);
        NSString * urlWhats = [NSString stringWithFormat:@"%@",currentUrl];
        NSString*encodestr=[NSString stringWithFormat:@"%@",[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURL * whatsappURL = [NSURL URLWithString:encodestr];
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else if ([currentUrl containsString:@"?"] && [currentUrl containsString:@"https://test.motormouth.club"]){
        [ProgressHUD show:@"Loading..." Interaction:YES];
        NSString*modifiedUrlWithqueryString = [NSString stringWithFormat:@"%@&query=mobileApp",currentUrl];
        NSURL *url = [NSURL URLWithString:modifiedUrlWithqueryString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self loadRequest:requestObj];
    }
    
    
    else if ([currentUrl containsString:@"https://test.motormouth.club"]){
        [ProgressHUD show:@"Loading..." Interaction:YES];
        NSString*modifiedUrlWithqueryString = [NSString stringWithFormat:@"%@?query=mobileApp",currentUrl];
        NSURL *url = [NSURL URLWithString:modifiedUrlWithqueryString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self loadRequest:requestObj];
    }
    if ([currentUrl containsString:@"mailto"]) {
        [ProgressHUD dismiss];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSString *currentUrl = webView.request.URL.absoluteString;
    if ([currentUrl isEqualToString:@"https://test.motormouth.club/login/?query=mobileApp"]){
        NSLog(@"%@",currentUrl);
        _webView.hidden = YES;
    }else{
        _webView.hidden = NO;
        
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //[ProgressHUD dismiss];
}
// Menu Button Click
- (IBAction)tapOnMenu:(id)sender {
    
    if (isBackActive == YES) {
        [self.webView goBack];
    }
    else{
        
        [self.view bringSubviewToFront:self.sliderView];
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self.sliderView setFrame:CGRectMake(170, 0, (self.view.frame.size.width ), self.view.frame.size.height)];   // last position
                             //self.btnMenuLeftConstraints.constant = 20;
                             NSLog(@"Slider view frame %f %f",self.sliderView.frame.size.width, self.sliderView.frame.size.width);
                         }
                         completion:nil];
    }
}
- (IBAction)MenuButton:(UIBarButtonItem *)sender {
    if (isBackActive == YES) {
        [self.webView goBack];
    }
    else{
        
        [self.view bringSubviewToFront:self.sliderView];
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self.sliderView setFrame:CGRectMake(150, 0, (self.view.frame.size.width ), self.view.frame.size.height)];   // last position
                             //self.btnMenuLeftConstraints.constant = 20;
                             NSLog(@"Slider view frame %f %f",self.sliderView.frame.size.width, self.sliderView.frame.size.width);
                         }
                         completion:nil];
    }
    
}

-(void)hideMenuView{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.sliderView setFrame:CGRectMake((self.view.frame.size.width)+200, 0, (self.view.frame.size.width ), self.view.frame.size.height)];   // last position
                         //self.btnMenuLeftConstraints.constant = 200;
                         NSLog(@"Slider view frame %f %f",self.sliderView.frame.size.width, self.sliderView.frame.size.width);
                     }
                     completion:nil];
}


#pragma table View delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"userName"] length] > 0 && [[defaults objectForKey:@"password"] length] > 0){
        return [self.arrMenu count] + 1  ;
    }
    else {
        return [self.arrMenu count] + 1;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:252/255.0f alpha:0.1];
    cell.selectedBackgroundView =  customColorView;
    [cell.textLabel setFont:[UIFont fontWithName:@"Oswald-Regular" size:16]];
    cell.imageView.frame = CGRectMake(0,0,36,36);
    cell.imageView.image = [UIImage imageNamed:@""];
    
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"";
        cell.backgroundColor = [UIColor colorWithRed:41/255.0f green:72/255.0f blue:91/255.0f alpha:1.0f];
        cell.imageView.image = [UIImage imageNamed:@"close"];
        
    }
    
    else if (indexPath.row == 1){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] length] > 0) {
            cell.textLabel.text = @"LOGOUT";
        }else{
            cell.textLabel.text = @"LOGIN";
        }
        
    }
    
    else{
        NSDictionary *dictMenu = [self.arrMenu objectAtIndex:indexPath.row - 1];
        [[cell textLabel]setText:[dictMenu valueForKey:@"menuName"]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // To "clear" the footer view
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"userName"] length] > 0){
        switch (indexPath.row) {
            case 0:
            {
                [self hideMenuView];
                break;
            }
            case 1:
            {
                [self hideMenuView];
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Logout"
                                             message:@"Are You Sure Want to Logout!"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                //Add Buttons
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"Yes"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                                                if ([[defaults objectForKey:@"userName"] length] > 0){
                                                    [self hideMenuView];
                                                    [defaults removeObjectForKey:@"userName"];
                                                    [defaults removeObjectForKey:@"password"];
                                                    [defaults removeObjectForKey:@"UserNameFromJs"];
                                                    [defaults synchronize];
                                                    _NotiFicationButton.hidden = true ;
                                                    _notificationButtonLeadingConst.constant = 20 ;
                                                    [self.arrMenu removeAllObjects];
                                                    self.arrMenu = [self createMenu];
                                                    
                                                    [self.tblMenu reloadData];
                                                    
                                                    [[NSURLCache sharedURLCache] removeAllCachedResponses];
                                                    
                                                    isComeFromLogin = NO;
                                                    
                                                    [self createMenuUrl:@"" andUserName:@"" andUrlTag:@""];
                                                    [self showTabBar];
                                                    [self createHomeTabAndTabUrl];
                                                    
                                                    
                                                }
                                                else{
                                                    [self hideMenuView];
                                                    [self performSegueWithIdentifier:@"segueLogin" sender:nil];
                                                }
                                            }];
                
                UIAlertAction* noButton = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                                               //Handle no, thanks button
                                           }];
                
                //Add your buttons to alert controller
                
                [alert addAction:yesButton];
                [alert addAction:noButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                break;
            }
                
            case 2:
            {
                [self hideMenuView];
                [self createMenuUrl:@"" andUserName:@"" andUrlTag:@""];
                [self showTabBar];
                [self createHomeTabAndTabUrl];
                break;
            }
            case 3:
            {
                if ([[defaults objectForKey:@"userName"] length] > 0){
                    
                    NSString*LoginuserName =[NSString stringWithFormat:@"%@/",UserNameFromJs] ;
                    [self createMenuUrl:@"members/" andUserName:LoginuserName andUrlTag:@""];
                    [self createProfileTabAndTabUrl];
                    [self showTabBar];
                    [self.collectionView reloadData];
                } else{
                    [self hideMenuView];
                    [self performSegueWithIdentifier:@"segueLogin" sender:nil];
                }
                [self showTabBar];
                break;
            }
                
            case 4:
            {
                if ([[defaults objectForKey:@"userName"] length] > 0) {
//                https://test.motormouth.club/groups/mine/
                    
                    
                    [self createMenuUrl:@"groups/" andUserName:@"" andUrlTag:@""];
                    [self createGroupsTabAndTabUrl];
                    [self showTabBar];
                    [self.collectionView reloadData];
                    break;
                }
                else{
                    [self hideMenuView];
                    [self performSegueWithIdentifier:@"segueLogin" sender:nil];
                }
            }
                
            case 5:
            {
                if ([[defaults objectForKey:@"userName"] length] > 0) {
                    NSString*LoginuserName =[NSString stringWithFormat:@"%@/",UserNameFromJs] ;
                    
                    [self createMenuUrl:@"members/" andUserName:LoginuserName andUrlTag:@"messages/"];
                }
                else{
                    [self hideMenuView];
                    [self performSegueWithIdentifier:@"segueLogin" sender:nil];
                }
                [self hideTabBar];
                break;
            }
                
            case 6:
            {
                if ([[defaults objectForKey:@"userName"] length] > 0) {
                    NSString*LoginuserName =[NSString stringWithFormat:@"%@/",UserNameFromJs] ;
                    
                    [self createMenuUrl:@"members/" andUserName:LoginuserName andUrlTag:@"settings/"];
                }
                else{
                    [self hideMenuView];
                    [self performSegueWithIdentifier:@"segueLogin" sender:nil];
                }
                [self hideTabBar];
                break;
            }
                
            case 7:
            {
                if ([[defaults objectForKey:@"userName"] length] > 0) {
                    [self hideMenuView];
                    [appDelegate.Notificationarray removeAllObjects];
                    self.counter.hidden = YES;
                    
                    [self performSegueWithIdentifier:@"Notification" sender:nil];
                    
                }
                else{
                    [self hideMenuView];
                    [self performSegueWithIdentifier:@"segueLogin" sender:nil];
                }
                [self hideTabBar];
                break;
            }
                
            case 8:
            {
                [self createMenuUrl:@"" andUserName:@"" andUrlTag:@"privacy-policy/"];
                [self hideTabBar];
                
                break;
            }
                
            case 9:
            {
                [self hideMenuView];
                [self createMenuUrl:@"" andUserName:@"" andUrlTag:@"terms/"];
                [self hideTabBar];
                break;
            }
                
            default:
                break;
        }
        
    }else{
        switch (indexPath.row) {
            case 0:
            {
                [self hideMenuView];
                break;
            }
            case 1:
            {
                if ([[defaults objectForKey:@"userName"] length] > 0){
                    [self hideMenuView];
                    [defaults removeObjectForKey:@"userName"];
                    [defaults removeObjectForKey:@"password"];
                    [defaults removeObjectForKey:@"UserNameFromJs"];
                    [defaults synchronize];
                    [self.tblMenu reloadData];
                    
                    [[NSURLCache sharedURLCache] removeAllCachedResponses];
                    
                    isComeFromLogin = NO;
                    
                    [self createMenuUrl:@"" andUserName:@"" andUrlTag:@""];
                    [self showTabBar];
                    [self createHomeTabAndTabUrl];
                    
                    
                }
                else{
                    [self hideMenuView];
                    [self performSegueWithIdentifier:@"segueLogin" sender:nil];
                }
                break;
            }
                
            case 2:
            {
                [self hideMenuView];
                [self createMenuUrl:@"" andUserName:@"" andUrlTag:@""];
                [self showTabBar];
                [self createHomeTabAndTabUrl];
                break;
            }
            case 3:
            {
                if ([[defaults objectForKey:@"userName"] length] > 0){
                    NSString*LoginuserName =[NSString stringWithFormat:@"%@/",UserNameFromJs] ;
                    [self createMenuUrl:@"members/" andUserName:LoginuserName andUrlTag:@""];
                    [self createProfileTabAndTabUrl];
                    [self showTabBar];
                    [self.collectionView reloadData];
                } else{
                    [self hideMenuView];
                    [self performSegueWithIdentifier:@"segueLogin" sender:nil];
                }
                [self showTabBar];
                break;
            }
                
            case 4:
            {
                //  https://test.motormouth.club/groups/mine/
                
                
                [self createMenuUrl:@"groups/" andUserName:@"" andUrlTag:@""];
                [self createGroupsTabAndTabUrl];
                [self showTabBar];
                [self.collectionView reloadData];
                break;
            }
                
            case 5:
            {
                if ([[defaults objectForKey:@"userName"] length] > 0) {
                    NSString*LoginuserName =[NSString stringWithFormat:@"%@/",UserNameFromJs] ;
                    
                    [self createMenuUrl:@"members/" andUserName:LoginuserName andUrlTag:@"messages/"];
                }
                else{
                    [self hideMenuView];
                    [self performSegueWithIdentifier:@"segueLogin" sender:nil];
                }
                break;
            }
                
            case 6:
            {
                if ([[defaults objectForKey:@"userName"] length] > 0) {
                    NSString*LoginuserName =[NSString stringWithFormat:@"%@/",UserNameFromJs] ;
                    
                    [self createMenuUrl:@"members/" andUserName:LoginuserName andUrlTag:@"settings/"];
                }
                else{
                    [self hideMenuView];
                    [self performSegueWithIdentifier:@"segueLogin" sender:nil];
                }
                [self hideTabBar];
                break;
            }
                
                
            case 7:
            {
                [self createMenuUrl:@"" andUserName:@"" andUrlTag:@"privacy-policy/"];
                [self hideTabBar];
                break;
            }
                
            case 8:
            {
                [self hideMenuView];
                [self createMenuUrl:@"" andUserName:@"" andUrlTag:@"terms/"];
                [self hideTabBar];
                break;
            }
                
            default:
                break;
        }
        
    }
}

-(void)createMenuUrl :(NSString *)member andUserName:(NSString *)userName andUrlTag:(NSString *)tag {
    [self hideMenuView];
    NSString *startUrl = @"https://test.motormouth.club/";
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@?query=mobileApp",startUrl,member,userName,tag];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self loadRequest:requestObj];
}

-(void)hideTabBar{
    CGRect webViewFrame = _webView.frame;
    webViewFrame.origin.y = 70 ;
    _webView.frame = webViewFrame;
    NSLog(@"webview frame %f",CGRectGetMaxY(self.collectionView.frame));
    self.collectionView.hidden = YES;
    _verticalConstantWebView.constant = 0 ;
}

-(void)showTabBar{
    CGRect webViewFrame = self.webView.frame;
    webViewFrame.origin.y = CGRectGetMaxY(self.collectionView.frame) ;
    self.webView.frame = webViewFrame;
    // [self.view sendSubviewToBack:self.webView];
    NSLog(@"webview frame %f",CGRectGetMaxY(self.collectionView.frame));
    self.collectionView.hidden = NO;
    _verticalConstantWebView.constant = 54 ;
    
}

// Add a delegate method to handle the tap and do something with it.

-(void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self.sliderView setFrame:CGRectMake(-(self.view.frame.size.width), 0, (self.view.frame.size.width), self.view.frame.size.height)];   // last position
                             //self.btnMenuLeftConstraints.constant = 200;
                             NSLog(@"Slider view frame %f %f",self.sliderView.frame.size.width, self.sliderView.frame.size.width);
                         }
                         completion:nil];
    }
}
// Create Menu Options
-(NSMutableArray *)createMenu{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *menuArr = [[NSMutableArray alloc] init];
    
    if ([[defaults objectForKey:@"userName"] length] > 0){
        NSMutableDictionary *menu1 = [[NSMutableDictionary alloc] init];
        [menu1 setObject:@"LOGIN" forKey:@"menuName"];
        [menuArr addObject:menu1];
        
        NSMutableDictionary *menu2 = [[NSMutableDictionary alloc] init];
        [menu2 setObject:@"HOME" forKey:@"menuName"];
        [menuArr addObject:menu2];
        
        NSMutableDictionary *menu3 = [[NSMutableDictionary alloc] init];
        [menu3 setObject:@"MY PROFILE" forKey:@"menuName"];
        [menuArr addObject:menu3];
        
        NSMutableDictionary *menu4 = [[NSMutableDictionary alloc] init];
        [menu4 setObject:@"GROUPS" forKey:@"menuName"];
        [menuArr addObject:menu4];
        
        NSMutableDictionary *menu5 = [[NSMutableDictionary alloc] init];
        [menu5 setObject:@"MESSAGES" forKey:@"menuName"];
        [menuArr addObject:menu5];
        
        NSMutableDictionary *menu6 = [[NSMutableDictionary alloc] init];
        [menu6 setObject:@"MY SETTINGS" forKey:@"menuName"];
        [menuArr addObject:menu6];
        
        NSMutableDictionary *menu7 = [[NSMutableDictionary alloc] init];
        [menu7 setObject:@"NOTIFICATIONS" forKey:@"menuName"];
        [menuArr addObject:menu7];
        
        NSMutableDictionary *menu8 = [[NSMutableDictionary alloc] init];
        [menu8 setObject:@"PRIVACY" forKey:@"menuName"];
        [menuArr addObject:menu8];
        
        NSMutableDictionary *menu9 = [[NSMutableDictionary alloc] init];
        [menu9 setObject:@"TERMS & CONDITIONS" forKey:@"menuName"];
        [menuArr addObject:menu9];
        
        
    }else{
        NSMutableDictionary *menu1 = [[NSMutableDictionary alloc] init];
        [menu1 setObject:@"LOGIN" forKey:@"menuName"];
        [menuArr addObject:menu1];
        
        NSMutableDictionary *menu2 = [[NSMutableDictionary alloc] init];
        [menu2 setObject:@"HOME" forKey:@"menuName"];
        [menuArr addObject:menu2];
        
        NSMutableDictionary *menu3 = [[NSMutableDictionary alloc] init];
        [menu3 setObject:@"MY PROFILE" forKey:@"menuName"];
        [menuArr addObject:menu3];
        
        NSMutableDictionary *menu4 = [[NSMutableDictionary alloc] init];
        [menu4 setObject:@"GROUPS" forKey:@"menuName"];
        [menuArr addObject:menu4];
        
        NSMutableDictionary *menu5 = [[NSMutableDictionary alloc] init];
        [menu5 setObject:@"MESSAGES" forKey:@"menuName"];
        [menuArr addObject:menu5];
        
        NSMutableDictionary *menu6 = [[NSMutableDictionary alloc] init];
        [menu6 setObject:@"MY SETTINGS" forKey:@"menuName"];
        [menuArr addObject:menu6];
        
        
        NSMutableDictionary *menu7 = [[NSMutableDictionary alloc] init];
        [menu7 setObject:@"PRIVACY" forKey:@"menuName"];
        [menuArr addObject:menu7];
        
        NSMutableDictionary *menu8 = [[NSMutableDictionary alloc] init];
        [menu8 setObject:@"TERMS & CONDITIONS" forKey:@"menuName"];
        [menuArr addObject:menu8];
        
        
    }
    
    return menuArr;
}

//Create tab bar
-(void)createHomeTabAndTabUrl{
    
    if (self.arrTab.count > 0) {
        [self.arrTab removeAllObjects];
    }
    
    NSMutableDictionary *tabDict1 = [[NSMutableDictionary alloc] init];
    [tabDict1 setObject:@"NEWS" forKey:@"tabName"];
    [tabDict1 setObject:@"https://test.motormouth.club/?query=mobileApp" forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict1];
    
    NSMutableDictionary *tabDict2 = [[NSMutableDictionary alloc] init];
    [tabDict2 setObject:@"MMTV" forKey:@"tabName"];
    [tabDict2 setObject:@"https://test.motormouth.club/mmtv/?query=mobileApp" forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict2];
    
    NSMutableDictionary *tabDict3 = [[NSMutableDictionary alloc] init];
    [tabDict3 setObject:@"PIT WALL" forKey:@"tabName"];
    [tabDict3 setObject:@"https://test.motormouth.club/pitwall/?query=mobileApp" forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict3];
    
    NSMutableDictionary *tabDict4 = [[NSMutableDictionary alloc] init];
    [tabDict4 setObject:@"TRENDING" forKey:@"tabName"];
    [tabDict4 setObject:@"https://test.motormouth.club/trending/?query=mobileApp" forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict4];
    
    [self.collectionView reloadData];
}
//Create Tabs when user clicks on Profile
-(void)createProfileTabAndTabUrl{
    
    if (self.arrTab.count > 0) {
        [self.arrTab removeAllObjects];
    }
    
    NSMutableDictionary *tabDict1 = [[NSMutableDictionary alloc] init];
    [tabDict1 setObject:@"POSTS" forKey:@"tabName"];
    NSString *PostUrlString = [NSString stringWithFormat:@"https://test.motormouth.club/members/%@/?query=mobileApp",UserNameFromJs];
    
    [tabDict1 setObject:PostUrlString forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict1];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *url = @"https://test.motormouth.club/members/";
    
    NSString *followingUrlString = [NSString stringWithFormat:@"%@%@%@?query=mobileApp",url,UserNameFromJs,@"/following"];
    NSMutableDictionary *tabDict2 = [[NSMutableDictionary alloc] init];
    [tabDict2 setObject:@"FOLLOWING" forKey:@"tabName"];
    [tabDict2 setObject:followingUrlString forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict2];
    
    NSString *followerUrlString = [NSString stringWithFormat:@"%@%@%@",url,UserNameFromJs,@"/followers?query=mobileApp"];
    
    NSMutableDictionary *tabDict3 = [[NSMutableDictionary alloc] init];
    [tabDict3 setObject:@"FOLLOWERS" forKey:@"tabName"];
    [tabDict3 setObject:followerUrlString forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict3];
    
    
    [self.collectionView reloadData];
}
//Create Tabs when user clicks on Group

-(void)createGroupsTabAndTabUrl{
    
    if (self.arrTab.count > 0) {
        [self.arrTab removeAllObjects];
    }
    NSMutableDictionary *tabDict1 = [[NSMutableDictionary alloc] init];
    [tabDict1 setObject:@"ALL GROUPS" forKey:@"tabName"];
    [tabDict1 setObject:@"https://test.motormouth.club/groups/?query=mobileApp" forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict1];
    
    NSMutableDictionary *tabDict2 = [[NSMutableDictionary alloc] init];
    
    [tabDict2 setObject:@"MY GROUPS" forKey:@"tabName"];
    [tabDict2 setObject:@"https://test.motormouth.club/groups/mine/?query=mobileApp" forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict2];
    
    
    
    
    NSMutableDictionary *tabDict3 = [[NSMutableDictionary alloc] init];
    [tabDict3 setObject:@"OFFICIAL" forKey:@"tabName"];
    [tabDict3 setObject:@"https://test.motormouth.club/groups/racing/?query=mobileApp" forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict3];
    
    NSMutableDictionary *tabDict4 = [[NSMutableDictionary alloc] init];
    [tabDict4 setObject:@"COMMUNITY" forKey:@"tabName"];
    [tabDict4 setObject:@"https://test.motormouth.club/groups/type/community/?query=mobileApp" forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict4];
    
    
    NSMutableDictionary *tabDict5 = [[NSMutableDictionary alloc] init];
    [tabDict5 setObject:@"POPULAR" forKey:@"tabName"];
    [tabDict5 setObject:@"https://test.motormouth.club/groups/popular/?query=mobileApp" forKey:@"tabUrl"];
    [self.arrTab addObject:tabDict5];
    
    
    [self.collectionView reloadData];
}
#pragma Collectionview Delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.arrTab count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    NSDictionary *tabDict = [self.arrTab objectAtIndex:indexPath.row];
    NSString*TabName = [tabDict objectForKey:@"tabName"];
    if ([TabName isEqualToString:@"ALL GROUPS"]) {
        cell.lblTabName.hidden = YES;
        cell.groupTabImageView.hidden = NO;
        cell.groupTabImageView.image = [UIImage imageNamed:@"ic_all_groups_selected"];
        
    }
    else if ([TabName isEqualToString:@"MY GROUPS"]) {
        cell.lblTabName.hidden = YES;
        cell.groupTabImageView.hidden = NO;
        cell.groupTabImageView.image = [UIImage imageNamed:@"ic_my_groups_unselected"];
        
    }
    else if ([TabName isEqualToString:@"OFFICIAL"]) {
        cell.lblTabName.hidden = YES;
        cell.groupTabImageView.hidden = NO;
        cell.groupTabImageView.image = [UIImage imageNamed:@"ic_official_groups_unselected"];
        
    }
    else if ([TabName isEqualToString:@"COMMUNITY"]) {
        cell.lblTabName.hidden = YES;
        cell.groupTabImageView.hidden = NO;
        cell.groupTabImageView.image = [UIImage imageNamed:@"ic_community_groups_unselected"];
        
    }
    else if ([TabName isEqualToString:@"POPULAR"]) {
        cell.lblTabName.hidden = YES;
        cell.groupTabImageView.hidden = NO;
        cell.groupTabImageView.image = [UIImage imageNamed:@"ic_popular_groups_unselected"];
        
    }else{
        cell.groupTabImageView.hidden = YES;
        
        cell.lblTabName.hidden = NO;
        
        cell.lblTabName.text = [tabDict objectForKey:@"tabName"];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        cell.lblBottomLine.hidden = NO;
    }
    else{
        cell.lblBottomLine.hidden = YES;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width / [self.arrTab count], 50);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        NSString *TabName;
        if (row == indexPath.row) {
            TabCollectionViewCell *cell = (TabCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            NSMutableDictionary *selectedTabDict = [self.arrTab objectAtIndex:indexPath.row];
            NSString *fullURL = [selectedTabDict valueForKey:@"tabUrl"];
            TabName = [selectedTabDict valueForKey:@"tabName"];
            if ([TabName isEqualToString:@"ALL GROUPS"]) {
                cell.groupTabImageView.image = [UIImage imageNamed:@"ic_all_groups_selected"];
                
            }
            if ([TabName isEqualToString:@"MY GROUPS"]) {
                cell.groupTabImageView.image = [UIImage imageNamed:@"ic_my_groups_selected"];
                
            }
            if ([TabName isEqualToString:@"OFFICIAL"]) {
                cell.groupTabImageView.image = [UIImage imageNamed:@"ic_official_groups_selected"];
                
            }
            if ([TabName isEqualToString:@"COMMUNITY"]) {
                cell.groupTabImageView.image = [UIImage imageNamed:@"ic_community_groups_selected"];
                
            }
            if ([TabName isEqualToString:@"POPULAR"]) {
                cell.groupTabImageView.image = [UIImage imageNamed:@"ic_popular_groups_selected"];
                
            }
            
            
            
            
            
            NSURL *url = [NSURL URLWithString:fullURL];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            
            [self loadRequest:requestObj];
            
            cell.lblBottomLine.hidden = NO;
        }
        else{
            NSInteger lastRow = row;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            TabCollectionViewCell *cell = (TabCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.lblBottomLine.hidden = YES;
            if (lastRow == 0) {
                cell.groupTabImageView.image = [UIImage imageNamed:@"ic_all_groups_unselected"];
                
            }
            if (lastRow == 1) {
                cell.groupTabImageView.image = [UIImage imageNamed:@"ic_my_groups_unselected"];
                
            }
            if (lastRow == 2) {
                cell.groupTabImageView.image = [UIImage imageNamed:@"ic_official_groups_unselected"];
                
            }
            if (lastRow == 3) {
                cell.groupTabImageView.image = [UIImage imageNamed:@"ic_community_groups_unselected"];
                
            }
            if (lastRow == 4) {
                cell.groupTabImageView.image = [UIImage imageNamed:@"ic_popular_groups_unselected"];
                
            }
            
        }
    }
}

- (IBAction)tapOnLogin:(id)sender {
    [appDelegate.Notificationarray removeAllObjects];
    self.counter.hidden = YES;
    [self performSegueWithIdentifier:@"Notification" sender:nil];
}

//Save known urls
-(NSMutableArray *)createUrlArray{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString*member = [NSString stringWithFormat:@"https://test.motormouth.club/members/%@/?query=mobileApp",UserNameFromJs];
    NSString*Follower = [NSString stringWithFormat:@"https://test.motormouth.club/members/%@/followers/?query=mobileApp",UserNameFromJs];
    NSString*Following = [NSString stringWithFormat:@"https://test.motormouth.club/members/%@/following/?query=mobileApp",UserNameFromJs];
    
    NSString*messages = [NSString stringWithFormat:@"https://test.motormouth.club/members/%@/messages/?query=mobileApp",UserNameFromJs];
    NSString*settings = [NSString stringWithFormat:@"https://test.motormouth.club/members/%@/settings/?query=mobileApp",UserNameFromJs];
    if (([[defaults objectForKey:@"userName"] length] > 0)) {
        [arr addObject:@"https://test.motormouth.club/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/"];
        [arr addObject:@"https://test.motormouth.club/login/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/login/?redirect_to"];
        [arr addObject:@"https://test.motormouth.club/wp-login.php"];
        [arr addObject:@"https://test.motormouth.club/register/"];
        [arr addObject:@"https://test.motormouth.club/login/?login=failed"];
        [arr addObject:@"https://test.motormouth.club/login/?login=blank"];
        [arr addObject:@"https://test.motormouth.club/mmtv/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/pitwall/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/trending/?query=mobileApp"];
        [arr addObject:member];
        [arr addObject:Follower];
        [arr addObject:Following];
        //[arr addObject:@"https://test.motormouth.club/members/franktest/groups/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/groups/mine/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/groups/type/community/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/groups/racing/?query=mobileApp"];
        
        [arr addObject:@"https://test.motormouth.club/groups/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/groups/popular/?query=mobileApp"];
        [arr addObject:messages];
        [arr addObject:settings];
        [arr addObject:@"https://test.motormouth.club/members/franktest/notifications/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/privacy-policy/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/terms/?query=mobileApp"];
        
    }else{
        [arr addObject:@"https://test.motormouth.club/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/"];
        [arr addObject:@"https://test.motormouth.club/login/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/login/?redirect_to"];
        [arr addObject:@"https://test.motormouth.club/wp-login.php"];
        [arr addObject:@"https://test.motormouth.club/register/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/login/?login=failed"];
        [arr addObject:@"https://test.motormouth.club/login/?login=blank"];
        [arr addObject:@"https://test.motormouth.club/mmtv/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/pitwall/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/trending/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/members/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/members/franktest/followers/"];
        [arr addObject:@"https://test.motormouth.club/members/franktest/following/"];
        [arr addObject:@"https://test.motormouth.club/members/franktest/groups/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/groups/mine/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/groups/type/community/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/groups/racing/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/groups/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/groups/popular/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/members/franktest/messages/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/members/franktest/settings/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/members/franktest/notifications/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/privacy-policy/?query=mobileApp"];
        [arr addObject:@"https://test.motormouth.club/terms/?query=mobileApp"];
    }
    return arr;
}
//Currently we are not using this method
-(void)checkBackButton:(NSString *)urlString{
    NSMutableArray *arr = [self createUrlArray];
    
    for (int i = 0; i < arr.count; i++) {
        if ([urlString isEqualToString:[arr objectAtIndex:i]]) {
            isBackActive = NO;
            [self.btnMenu setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
            
            
            return;
        }
        else{
            isBackActive = NO;
            [self.btnMenu setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
            
            //            isBackActive = YES;
            //            [self.btnMenu setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            
        }
    }
    
}
- (IBAction)notificationAction:(id)sender {
    [self performSegueWithIdentifier:@"Notification" sender:nil];
    
}
#pragma HandlePush Notification
-(void)remoteNotificationHandler:(NSNotification *) notification {
    self.counter.hidden = NO;
    
    self.counter.text = [NSString stringWithFormat:@"%lu",(unsigned long)appDelegate.Notificationarray.count];
}

- (IBAction)searchViewController:(id)sender {
    [self performSegueWithIdentifier:@"segue_Search" sender:nil];
    
}




@end
