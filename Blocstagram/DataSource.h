//
//  DataSource.h
//  Blocstagram
//
//  Created by Cynthia Whitlatch on 5/11/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Media;
typedef void (^NewItemCompletionBlock)(NSError *error);

@interface DataSource : NSObject

+ (NSString *) instagramClientID;

@property (nonatomic, strong, readonly) NSString *accessToken;
@property (nonatomic, strong, readonly) NSArray *mediaItems;

+(instancetype) sharedInstance;

- (void) deleteMediaItem:(Media *)item;
- (void) requestNewItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler;
- (void) requestOldItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler;

@end
