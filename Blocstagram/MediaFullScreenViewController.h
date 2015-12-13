//
//  MediaFullScreenViewController.h
//  Blocstagram
//
//  Created by Cynthia Whitlatch on 5/24/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;

@interface MediaFullScreenViewController : UIViewController

@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

- (instancetype) initWithMedia:(Media *)media;

- (void) centerScrollView;
- (void) recalculateZoomScale;

@end
