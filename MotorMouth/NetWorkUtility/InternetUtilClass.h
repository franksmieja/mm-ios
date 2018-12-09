//
//  InternetUtilClass.h
//  NetWorkDetectorModule
//
//  Created by Htpl09 on 01/07/16.
//  Copyright © 2016 ht. All rights reserved.
//

#define NETWORK_ERROR_MSG  @"No Internet Connection. Make sure your device is connected to the internet."

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface InternetUtilClass : NSObject
@property (strong, nonatomic) Reachability *reachability;

/**
 Get the class shared instance.
 **/
+ (id) sharedInstance;

/**
 Check the network status i.e Network connected or not.
 **/
- (BOOL) hasConnectivity;
@end
