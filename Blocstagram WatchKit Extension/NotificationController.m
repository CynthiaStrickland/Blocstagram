//
//  NotificationController.m
//  Blocstagram WatchKit Extension
//
//  Created by Cynthia Whitlatch on 6/19/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import "NotificationController.h"
#import "InterfaceController.h"
#import <WatchKit/watchKit.h>
#import "Appdelegate.h"


@interface NotificationController()

@property(nonatomic) UILocalNotification *localNotification;
@property(nonatomic, copy) NSString *alertAction;
@property(nonatomic, copy) NSString *alertBody;
@property(nonatomic) NSCalendarUnit repeatInterval;
@property(nonatomic, copy) NSDate *fireDate;

@end


@implementation NotificationController

- (instancetype)init {
    self = [super init];
    if (self){
        // Initialize variables here.
        // Configure interface objects here.
    
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        self.localNotification.alertAction = @"Post to Instagram";
        self.localNotification.alertBody = [NSString stringWithFormat:@"Reach your publishing goal. Post to Instagram now."];
        self.localNotification.repeatInterval = NSCalendarUnitMinute;
        self.localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(120)];
        self.localNotification.timeZone = [NSTimeZone defaultTimeZone];

        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

/*
- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
    // This method is called when a local notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}
*/

/*
- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
    // This method is called when a remote notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}
*/

@end



