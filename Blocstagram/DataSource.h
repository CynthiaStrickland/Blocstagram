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

+(instancetype) sharedInstance;

@property (nonatomic, strong, readonly) NSArray *mediaItems;

- (void) deleteMediaItem:(Media *)item;

- (void) requestNewItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler;

- (void) requestOldItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler;

@end
