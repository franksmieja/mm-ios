//
//  InternetUtilClass.m
//  NetWorkDetectorModule
//
//  Created by Htpl09 on 01/07/16.
//  Copyright © 2016 ht. All rights reserved.
//

#import "InternetUtilClass.h"

@implementation InternetUtilClass

/**
 Create and retuen shared instance of the class.
 **/
+ (id)sharedInstance {
    static InternetUtilClass *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark Private Initialization
/**
 Initialize the class variable.
 **/
- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityForInternetConnection];
        
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}
/**
  Check Internet Connectivity using the Rechability class.
 **/
-(BOOL) hasConnectivity {
    int networkStatus = [[[InternetUtilClass sharedInstance] reachability] currentReachabilityStatus];
    return networkStatus != 0;
}

#pragma mark Memory Management
- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}


@end
