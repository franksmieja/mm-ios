//
//  AppDelegate.m
//  MotorMouth
//
//  Created by Pushpendra on 11/10/17.
//  Copyright © 2017 Pushpendra. All rights reserved.
//

#import "AppDelegate.h"
#import "WebViewController.h"
#import "ProgressHUD.h"
#import "NotificationListing+CoreDataProperties.h"
#import <UserNotifications/UserNotifications.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseInstanceID;


@interface AppDelegate ()<UIApplicationDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FIRApp configure];
    // 4.request a device Token from apple push Notification services
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    [application registerForRemoteNotifications];
    
    
     [FIRMessaging messaging].delegate = self;
    _NotificationDict =[[NSMutableDictionary alloc]init];
    _Notificationarray = [[NSMutableArray alloc]init];
    
    NSLog(@"fir token is %@",[[FIRInstanceID instanceID] token]);
    //    [self notifylist:@"Hi Frank" msg:@"This is test notification for motor mouth" markAsRead:@"no"];
    //    [_NotificationDict setObject:@"Hi Frank" forKey:@"message"];
    //    [_NotificationDict setObject:@"This is test notification for motor mouth" forKey:@"title"];
    //    [_NotificationDict setObject:@"NO" forKey:@"ReadStatus"];
    //    [self.Notificationarray addObject:_NotificationDict];
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteNotification" object:nil userInfo:nil];
    
    return YES;
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;
    // For Development
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
    
    // For Production
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type: FIRInstanceIDAPNSTokenTypeProd];
    
    
    //[[FIRMessaging messaging] subscribeToTopic:@"/topics/MM"];
    [[FIRMessaging messaging] subscribeToTopic:@"/topics/MM_Notification"];
    
}

// Delegation methods

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // print full message .
    if (userInfo[@"gcm.message_id"]) {
        NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    }
    NSLog(@"Message ID: %@", userInfo[@"body"]);
    NSLog(@"Message ID: %@", userInfo[@"title"]);
    // [self notifylist:userInfo[@"body"] msg:userInfo[@"title"] markAsRead:@"no"];
    //  [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteNotification" object:nil userInfo:nil];
    NSDictionary*dic = userInfo;
    NSDictionary*dictmsg = [userInfo valueForKey:@"aps"];
    NSDictionary*dictAlert = [dictmsg valueForKey:@"alert"];
    NSString*msg = [dictAlert valueForKey:@"body"];
    NSString*title = [dictAlert valueForKey:@"title"];
    [self.NotificationDict removeAllObjects];
    completionHandler(UNNotificationPresentationOptionAlert);
    
    [self notifylist:title msg:msg markAsRead:@"no"];
    [_NotificationDict setObject:title forKey:@"message"];
    [_NotificationDict setObject:msg forKey:@"title"];
    [_NotificationDict setObject:@"NO" forKey:@"ReadStatus"];
    [self.Notificationarray addObject:_NotificationDict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteNotification" object:nil userInfo:self.Notificationarray];
    
    
    NSLog(@"%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog( @"Handle push from background or closed" );
    // if you set a member variable in didReceiveRemoteNotification, you will know if this is from closed or background
    NSLog(@"Notification Dict didReceiveRemoteNotification : %@",userInfo);
    // Manage the type of notification and then move to respective view.
    
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter* )center willPresentNotification:(UNNotification* )notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog( @"Here handle push notification in foreground" );
    //For notification Banner - when app in foreground
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNNotificationPresentationOptionAlert);
    //SET NOTIFICATION IN LOCAL DATABASE
    NSDictionary*dic = notification.request.content.userInfo;
    NSDictionary*dictmsg = [dic valueForKey:@"aps"];
    NSDictionary*dictAlert = [dictmsg valueForKey:@"alert"];
    NSString*msg = [dictAlert valueForKey:@"body"];
    NSString*title = [dictAlert valueForKey:@"title"];
    [self.NotificationDict removeAllObjects];
    
    [self notifylist:title msg:msg markAsRead:@"no"];
    [_NotificationDict setObject:title forKey:@"message"];
    [_NotificationDict setObject:msg forKey:@"title"];
    [_NotificationDict setObject:@"NO" forKey:@"ReadStatus"];
    [self.Notificationarray addObject:_NotificationDict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteNotification" object:nil userInfo:self.Notificationarray];
    
    // Print Notification info
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
}

#pragma mark -- Custom Firebase Code

- (void) tokenRefreshCallback: (NSNotification *)notification{
    NSString *refreshedToken  = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token : %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attemted before having a token
    [self connectToFirebase];
}
- (void) connectToFirebase{
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect FCM, %@", error);
            
        }else{
            NSLog(@"Connected To FCM ");
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

#pragma CoreData Methods

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize fetchedResultsController;
@synthesize notificationResultsController;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "proj.oms.bluetify" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}



- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
- (NSEntityDescription *)notificationEntity:(NSManagedObjectContext *)moc
{
    // This is a public method, and may be invoked on any queue.
    // So be sure to go through the public accessor for the entity name.
    return [NSEntityDescription entityForName:@"NotificationListing" inManagedObjectContext:moc];
}

-(void)notifylist:(NSString*)Title msg:(NSString*)message  markAsRead:(NSString*)markAsRead{
    NotificationListing *notificationEntity=(NotificationListing *)
    
    
    
    [[NSManagedObject alloc] initWithEntity:[self notificationEntity: [self managedObjectContext ]]
             insertIntoManagedObjectContext:[self managedObjectContext]];
    
    notificationEntity.messageTitle = Title;
    notificationEntity.message = message;
    notificationEntity.markAsRead = markAsRead;
    [self saveContext];
    
    
    
    
    
    NSMutableArray *array=[self fetchNotiFication];
    
    
    
    
    
}
- (NSArray *)fetchNotiFication {
    
    if (notificationResultsController != nil) {
        NSError *error;
        [notificationResultsController performFetch:&error];
        return notificationResultsController.fetchedObjects;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"NotificationListing" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"messageTitle" ascending:YES];
    [fetchRequest setSortDescriptors:[NSMutableArray arrayWithObject:sort]];
    
    // [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil
                                                   cacheName:nil];
    notificationResultsController = theFetchedResultsController;
    //    fetchedResultsController.delegate = self;
    NSError *error;
    [notificationResultsController performFetch:&error];
    return notificationResultsController.fetchedObjects;
}
#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end

