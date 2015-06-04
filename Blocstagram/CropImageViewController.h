//
//  CropImageViewController.h
//  Blocstagram
//
//  Created by Cynthia Whitlatch on 6/3/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MediaFullScreenViewController.h"

@class CropImageViewController;

@protocol CropImageViewControllerDelegate <NSObject>

- (void)cropControllerFinishedWithImage:(UIImage *)croppedImage;

@end

@interface CropImageViewController : MediaFullScreenViewController

- (instancetype)initWithImage:(UIImage *)sourceImage;

@property (nonatomic, weak) NSObject <CropImageViewControllerDelegate> *delegate;

@end