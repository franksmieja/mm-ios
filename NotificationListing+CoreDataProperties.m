//
//  NotificationListing+CoreDataProperties.m
//  
//
//  Created by Pushpendra on 09/01/18.
//
//  This file was automatically generated and should not be edited.
//

#import "NotificationListing+CoreDataProperties.h"

@implementation NotificationListing (CoreDataProperties)

+ (NSFetchRequest<NotificationListing *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NotificationListing"];
}

@dynamic message;
@dynamic iD;
@dynamic messageTitle;
@dynamic markAsRead;

@end
