//
//  InterfaceController.m
//  Blocstagram WatchKit Extension
//
//  Created by Cynthia Whitlatch on 6/19/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import "InterfaceController.h"
#import "MediaTableViewCell.h"
#import "Datasource.h"
#import "User.h"


//#import <WatchKit.h>



@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceTable *InstagramTable;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self.InstagramTable setNumberOfRows:15 withRowType:(@"InstagramRow")];
    
}

- (instancetype) initWithDictionary:(NSDictionary *)userDictionary {
        self = [super init];
        
        if (self) {
            self.idNumber = userDictionary[@"id"];
            self.userName = userDictionary[@"username"];
            self.fullName = userDictionary[@"full_name"];
            
            NSString *profileURLString = userDictionary[@"profile_picture"];
            NSURL *profileURL = [NSURL URLWithString:profileURLString];
            
            if (profileURL) {
                self.profilePictureURL = profileURL;
            }
        }
        
        return self;
    }
    
//    - (instancetype) init {
//        self = [super init];
//        
//        if (self) {
//            
//            // ****** CALLING THE METHOD OPERATION MANAGER ******
//            
//            [self createOperationManager];
//            self.accessToken = [UICKeyChainStore stringForKey:@"access token"];
//            
//            if (!self.accessToken) {
//                [self registerForAccessTokenNotification];
//                
//            } else {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(mediaItems))];
//                    NSArray *storedMediaItems = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (storedMediaItems.count > 0) {
//                            NSMutableArray *mutableMediaItems = [storedMediaItems mutableCopy];
//                            [self willChangeValueForKey:@"mediaItems"];
//                            self.mediaItems = mutableMediaItems;
//                            [self didChangeValueForKey:@"mediaItems"];
//                            
//                        } else {
//                            [self populateDataWithParameters:nil completionHandler:nil];
//                        }
//                    });
//                });
//            }
//        }    
//        return self;
//    }
//
//    
//    
//}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



