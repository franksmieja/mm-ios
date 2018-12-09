//
//  AppDelegate.h
//  MotorMouth
//
//  Created by Pushpendra on 11/10/17.
//  Copyright © 2017 Pushpendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSMutableDictionary*NotificationDict;
@property (nonatomic,strong) NSMutableArray*Notificationarray;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (readonly, strong, nonatomic) NSFetchedResultsController *notificationResultsController;

- (void)saveContext ;
- (NSArray *)fetchNotiFication;
- (NSURL *)applicationDocumentsDirectory;

@end

