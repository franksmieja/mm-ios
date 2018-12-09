//
//  NotificationViewController.m
//  MotorMouth
//
//  Created by Pushpendra on 08/01/18.
//  Copyright © 2018 Pushpendra. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCellTableViewCell.h"
#import "AppDelegate.h"
#import "NotificationListing+CoreDataProperties.h"

@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray*NotificationArrray;
    AppDelegate *appDelegate;

    
}
@property (strong, nonatomic) IBOutlet UITableView *notificationTable;

@property (strong, nonatomic) IBOutlet UILabel *MessageTileLbl;
@property (strong, nonatomic) IBOutlet UILabel *MsgLabel;
@property (strong, nonatomic) IBOutlet UIView *ShowMessageView;

@property (strong, nonatomic) IBOutlet UIView *MessageView;

@property (weak, nonatomic) IBOutlet UILabel *noNotificationLbl;

@end

@implementation NotificationViewController
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NotificationArrray = [[NSMutableArray alloc]init];
    //Fetch Notifications from local db
    NotificationArrray = [[self appDelegate ]fetchNotiFication];
    [appDelegate.Notificationarray removeAllObjects];
    if (NotificationArrray.count == 0 ) {
        _notificationTable.hidden = true;
    }else{
        _notificationTable.hidden = false;
        self.noNotificationLbl.hidden = true ;
        _notificationTable.delegate = self;
        _notificationTable.dataSource = self;
        self.notificationTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma amrk - UITableView Delegate Method for Autocomplete API
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self appDelegate]fetchNotiFication].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1.0];
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView =  customColorView;


    NSDictionary*dict = [NotificationArrray objectAtIndex:indexPath.row];
    cell.MsgtitleLbl.text = [[[[self appDelegate]fetchNotiFication] objectAtIndex:indexPath.row] valueForKey:@"messageTitle"];
    cell.MsgLbl.text = [[[[self appDelegate]fetchNotiFication] objectAtIndex:indexPath.row] valueForKey:@"message"];
    NSString*readMark = [[[[self appDelegate]fetchNotiFication] objectAtIndex:indexPath.row] valueForKey:@"markAsRead"];
    if ([readMark isEqualToString:@"Yes"]) {
        cell.backgroundColor = [UIColor clearColor];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.ShowMessageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_ShowMessageView];
    [self.ShowMessageView bringSubviewToFront:_MessageView];
    NotificationCellTableViewCell *cell = (NotificationCellTableViewCell *)[self.notificationTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];

    cell.backgroundColor = [UIColor clearColor];
    NSString*readMark = [[[[self appDelegate]fetchNotiFication] objectAtIndex:indexPath.row] valueForKey:@"markAsRead"];
    if (([readMark isEqualToString:@"no"])) {
        NotificationListing *notificationRead=[[[self appDelegate]fetchNotiFication] objectAtIndex:indexPath.row];
        notificationRead.markAsRead= @"Yes";
        [[self appDelegate] saveContext];

    }
            self.MessageView.layer.cornerRadius = 5;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (IBAction)tapOnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)TapOnOK:(id)sender {
    [self.ShowMessageView removeFromSuperview];
}

@end
