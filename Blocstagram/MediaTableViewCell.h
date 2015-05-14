//
//  MediaTableViewCell.h
//  Blocstagram
//
//  Created by Cynthia Whitlatch on 5/13/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;

@interface MediaTableViewCell : UITableViewCell

@property (nonatomic,strong) Media *mediaItem;

+ (CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width;
- (Media *)mediaItem;
- (void)setMediaItem:(Media *)mediaItem;

@end
