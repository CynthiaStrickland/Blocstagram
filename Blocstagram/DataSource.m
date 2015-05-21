//
//  DataSource.m
//  Blocstagram
//
//  Created by Cynthia Whitlatch on 5/11/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import "DataSource.h"
#import "User.h"
#import "Media.h"
#import "Comment.h"
#import "LoginViewController.h"

@interface DataSource () {
    NSMutableArray *_mediaItems;
}

@property (nonatomic, strong) NSArray *mediaItems;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadingOlderItems;
@property (nonatomic, strong) NSString *accessToken;

@end

@implementation DataSource

+ (NSString *) instagramClientID {
    return @"eeb5d2b7dea143d088e51a47b7035aee";   // ********   DO I REALLY PUT MY CLIENT ID HERE ??? *******
}

//CORRECT***********
- (void) parseDataFromFeedDictionary:(NSDictionary *) feedDictionary fromRequestWithParameters:(NSDictionary *)parameters {
    
    NSArray *mediaArray = feedDictionary[@"data"];
    
    NSMutableArray *tmpMediaItems = [NSMutableArray array];
    
    for (NSDictionary *mediaDictionary in mediaArray) {
        Media *mediaItem = [[Media alloc] initWithDictionary:mediaDictionary];
        
        if (mediaItem) {
                [tmpMediaItems addObject:mediaItem];
                [self downloadImageForMediaItem:mediaItem];
            }
        }
        
        [self willChangeValueForKey:@"mediaItems"];
        self.mediaItems = tmpMediaItems;
        [self didChangeValueForKey:@"mediaItems"];
    }

//CORRECT ***************
- (void) downloadImageForMediaItem:(Media *)mediaItem {
    if (mediaItem.mediaURL && !mediaItem.image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:mediaItem.mediaURL];
            
            NSURLResponse *response;
            NSError *error;
            NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                
                if (image) {
                    mediaItem.image = image;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
                        NSUInteger index = [mutableArrayWithKVO indexOfObject:mediaItem];
                        [mutableArrayWithKVO replaceObjectAtIndex:index withObject:mediaItem];
                    });
                }
            } else {
                NSLog(@"Error downloading image: %@", error);
            }
        });
    }
}
    
- (void) requestNewItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler {
    // #1
    if (self.isRefreshing == NO) {
        self.isRefreshing = YES;
        
        NSString *minID = [[self.mediaItems firstObject] idNumber];
        NSDictionary *parameters;
        
        if (minID) {
            parameters = @{@"min_id": minID};
        }
        [self populateDataWithParameters:parameters completionHandler:^(NSError *error) {
            
            self.isRefreshing = NO;
            
            if (completionHandler) {
                completionHandler(error);
            }
        }];
    }
}

- (void) requestOldItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler {
    if (self.isLoadingOlderItems == NO) {
        self.isLoadingOlderItems = YES;

        // TODO: Add images ***************
        
        self.isLoadingOlderItems = NO;

        if (completionHandler) {
            completionHandler(nil);
        }
    }
}

    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];

    if (parameters[@"min_id"]) {
        // This was a pull-to-refresh request

        NSRange rangeOfIndexes = NSMakeRange(0, tmpMediaItems.count);
        NSIndexSet *indexSetOfNewObjects = [NSIndexSet indexSetWithIndexesInRange:rangeOfIndexes];

        [mutableArrayWithKVO insertObjects:tmpMediaItems atIndexes:indexSetOfNewObjects];
    } else {
        [self willChangeValueForKey:@"mediaItems"];
        self.mediaItems = tmpMediaItems;
        [self didChangeValueForKey:@"mediaItems"];
    }

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
           sharedInstance = [[self alloc] init];
       });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        [self registerForAccessTokenNotification];
    }
    
    return self;
}

- (void) registerForAccessTokenNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:LoginViewControllerDidGetAccessTokenNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.accessToken = note.object;
        
        //HAVE A TOKEN; POPULATE THE INITIAL DATA
        [[self populateDataWithParameters:nil completeionHandler:nil];
    }];
}

#pragma mark - Key/Value Observing

- (NSUInteger) countOfMediaItems {
    return self.mediaItems.count;
}

- (NSArray *) mediaItemsAtIndexes:(NSIndexSet *)indexes {
    return [self.mediaItems objectsAtIndexes:indexes];
}

- (void) insertObject:(Media *)object inMediaItemsAtIndex:(NSUInteger)index {
    [_mediaItems insertObject:object atIndex:index];
}

- (void) removeObjectFromMediaItemsAtIndex:(NSUInteger)index {
    [_mediaItems removeObjectAtIndex:index];
}

- (void) replaceObjectInMediaItemsAtIndex:(NSUInteger)index withObject:(id)object {
    [_mediaItems replaceObjectAtIndex:index withObject:object];
}

- (void) deleteMediaItem:(Media *)item {
    NSMutableArray *mutableArraywithKVO = [self mutableArrayValueForKey:@"mediaItem"];
    [mutableArraywithKVO removeObject:item];
}

- (void) populateDataWithParameters:(NSDictionary *)parameters completeionHandler:(NewItemCompletionBlock)completionHandler {
    
    if (self.accessToken) {
        // only try to get the data if there's access token
        
                    dispatch_async(dispatch_get_main_queue(), ^{
        // done networking, go back on the main thread
                    [self parseDataFromFeedDictionary:feedDictionary fromRequestWithParameters:parameters];

                            if (completionHandler) {
                                completionHandler(nil);
                            }
                        });
                    } else if (completionHandler) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler(jsonError);
                        });
                    }
                } else if (completionHandler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(webError);
                        });
                    }

 
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // do the network request in the background, so the UI doesn't lock up
//
//            NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?access_token=%@", self.accessToken];
//
//            for (NSString *parameterName in parameters) {
//                // for example, if dictionary contains {count: 50}, append `&count=50` to the URL
//                [urlString appendFormat:@"&%@=%@", parameterName, parameters[parameterName]];
//            }
//
//            NSURL *url = [NSURL URLWithString:urlString];
//
//            if (url) {
//                NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//                NSURLResponse *response;
//                NSError *webError;
//                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&webError];
//
//                if (responseData) {
//                    NSError *jsonError;
//                    NSDictionary *feedDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
//
//                    if (feedDictionary) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            // done networking, go back on the main thread
//                            [self parseDataFromFeedDictionary:feedDictionary fromRequestWithParameters:parameters];
//
//                            if (completionHandler) {
//                                completionHandler(nil);
//                            }
//                        });
//                    } else if (completionHandler) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            completionHandler(jsonError);
//                        });
//                    }
//                } else if (completionHandler) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        completionHandler(webError);
//                    });
//                }
//            }
//        });
//
        
        

        


@end
