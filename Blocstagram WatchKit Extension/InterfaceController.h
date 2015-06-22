//
//  InterfaceController.h
//  Blocstagram WatchKit Extension
//
//  Created by Cynthia Whitlatch on 6/19/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController

- (instancetype) initWithDictionary:(NSDictionary *)userDictionary;

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSURL *profilePictureURL;

@end
