//
//  NotificationListing+CoreDataProperties.h
//  
//
//  Created by Pushpendra on 09/01/18.
//
//  This file was automatically generated and should not be edited.
//

#import "NotificationListing+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NotificationListing (CoreDataProperties)

+ (NSFetchRequest<NotificationListing *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic) int64_t iD;
@property (nullable, nonatomic, copy) NSString *messageTitle;
@property (nullable, nonatomic, copy) NSString *markAsRead;

@end

NS_ASSUME_NONNULL_END
