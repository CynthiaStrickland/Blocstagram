//
//  ImageLibraryCollectionViewController.h
//  Blocstagram
//
//  Created by Cynthia Whitlatch on 6/3/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageLibraryCollectionViewController;

@protocol ImageLibraryCollectionViewControllerDelegate <NSObject>

- (void)imageLibraryCollectionViewController:(ImageLibraryCollectionViewController *)imageLibraryCollectionViewController didCompleteWithImage:(UIImage *)image;

@end

@interface ImageLibraryCollectionViewController : UICollectionViewController

@property (nonatomic, weak) NSObject <ImageLibraryCollectionViewControllerDelegate> *delegate;

@end
