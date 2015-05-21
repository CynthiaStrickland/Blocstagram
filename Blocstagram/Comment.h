//
//  Comment.h
//  Blocstagram
//
//  Created by Cynthia Whitlatch on 5/11/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Comment : NSObject

- (instancetype) initWithDictionary:(NSDictionary *)commentDictionary;

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) User *from;
@property (nonatomic, strong) NSString *text;

@end
