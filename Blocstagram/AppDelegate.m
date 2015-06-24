//
//  AppDelegate.m
//  Blocstagram
//
//  Created by Cynthia Whitlatch on 5/11/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import "AppDelegate.h"
#import "ImagesTableTableViewController.h"
#import "LoginViewController.h"
#import "DataSource.h"

@interface AppDelegate ()

@property(nonatomic) UILocalNotification *localNotification;
@property(nonatomic, copy) NSString *alertAction;
@property(nonatomic, copy) NSString *alertBody;
@property(nonatomic) NSCalendarUnit repeatInterval;
@property(nonatomic, copy) NSDate *fireDate;

@end

@implementation AppDelegate

// This method will be called everytime you open the app and Register the deviceToken on Pushbots

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[Pushbots sharedInstance] registerOnPushbots:deviceToken];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Notification Registration Error %@", [error userInfo]);
}

//Handle notification when the user click it while app is running in background or foreground.

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[Pushbots sharedInstance] receivedPush:userInfo];
}

-(void) receivedPush:(NSDictionary *)userInfo {
    //Try to get Notification from [didReceiveRemoteNotification] dictionary
    NSDictionary *pushNotification = [userInfo objectForKey:@"aps"];
    
    if(!pushNotification) {
        //Try as launchOptions dictionary
        userInfo = [userInfo objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        pushNotification = [userInfo objectForKey:@"aps"];
    }
    
    if (!pushNotification)
        return;
    
    //Get notification payload data [Custom fields] For example: get viewControllerIdentifer for deep linking
    NSString* notificationViewControllerIdentifer = [userInfo objectForKey:@"notification_identifier"];
    
    //Set the default viewController Identifer
    if(!notificationViewControllerIdentifer)
        notificationViewControllerIdentifer = @"home";
    
    UIAlertView *message =
    [[UIAlertView alloc] initWithTitle:@"Notification"
                               message:[pushNotification valueForKey:@"alert"]
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles: @"OK",
     nil];
    
    [message show];
    return;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        [[Pushbots sharedInstance] OpenedNotification];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //INITIALIZES PUSHBOTS LIBRARY
    
    [Pushbots sharedInstanceWithAppId:@"558879fc177959a5738b4567"];
    //Handle notification when the user click it, while app is closed.
    //This method will show an alert to the user.
    [[Pushbots sharedInstance] receivedPush:launchOptions];
    
    {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        [DataSource sharedInstance];
        
        
        // create the data source (so it can receive the access token notification)
        
        UINavigationController *navVC = [[UINavigationController alloc] init];
        
        if (![DataSource sharedInstance].accessToken) {
            
            // these lines are unchanged; just indent them.
            
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [navVC setViewControllers:@[loginVC] animated:YES];
            
            [[NSNotificationCenter defaultCenter] addObserverForName:LoginViewControllerDidGetAccessTokenNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                ImagesTableTableViewController *imagesVC = [[ImagesTableTableViewController alloc] init];
                [navVC setViewControllers:@[imagesVC] animated:YES];
            }];
        } else {
            ImagesTableTableViewController *imagesVC = [[ImagesTableTableViewController alloc] init];
            [navVC setViewControllers:@[imagesVC] animated:YES];
        }
        self.window.rootViewController = navVC;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
        return YES;
    }
    
}

-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
