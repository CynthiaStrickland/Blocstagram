//
//  ImageLibraryCollectionViewController.m
//  Blocstagram
//
//  Created by Andrew Carvajal on 4/19/15.
//  Copyright (c) 2015 graffme, Inc. All rights reserved.
//

#import "ImageLibraryCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CropImageViewController.h"
#import <Photos/Photos.h>

@interface ImageLibraryCollectionViewController ()
<CropImageViewControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PHFetchResult *result;
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *arrayOfAssets;

@end

@implementation ImageLibraryCollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    
    return [super initWithCollectionViewLayout:layout];
}

//    if (self) {
//        self.library = [[ALAssetsLibrary alloc] init];
//        self.groups = [NSMutableArray array];
//        self.arrayOfAssets = [NSMutableArray array];
//    }
//    return self;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIImage *cancelImage = [UIImage imageNamed:@"x"];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:cancelImage style:UIBarButtonItemStyleDone target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)cancelPressed:(UIBarButtonItem *)sender {
    [self.delegate imageLibraryCollectionViewController:self didCompleteWithImage:nil];
}

- (void) viewWillLayoutSubviews {
        [super viewWillLayoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat minWidth = 100;
    NSInteger divisor = width / minWidth;
    CGFloat cellSize = width / divisor;

    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(cellSize, cellSize);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
}

- (void) loadAssets {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    self.result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadAssets];
                        [self.collectionView reloadData];
                    });
                }
            }];
        } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            [self loadAssets];
        }
    }

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.result.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSInteger imageViewTag = 54321;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:imageViewTag];
    
    if (!imageView) {
            imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
            imageView.tag = imageViewTag;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
        }
    
    if (cell.tag != 0) {
            [[PHImageManager defaultManager] cancelImageRequest:(PHImageRequestID)cell.tag];
        }
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    PHAsset *asset = self.result[indexPath.row];

    cell.tag = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:flowLayout.itemSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            UICollectionViewCell *cellToUpdate = [collectionView cellForItemAtIndexPath:indexPath];
        
            if (cellToUpdate) {
                    UIImageView *imageView = (UIImageView *)[cellToUpdate.contentView viewWithTag:imageViewTag];
                imageView.image = result;
                }
        }];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.result[indexPath.row];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *resultImage, NSDictionary *info)
            {
                    CropImageViewController *cropVC = [[CropImageViewController alloc] initWithImage:resultImage];
                cropVC.delegate = self;
                    [self.navigationController pushViewController:cropVC animated:YES];
                }];
    
}

#pragma mark - CropImageViewControllerDelegate

- (void) cropControllerFinishedWithImage:(UIImage *)croppedImage {
    [self.delegate imageLibraryCollectionViewController:self didCompleteWithImage:croppedImage];
}


//*********




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.groups removeAllObjects];
    [self.arrayOfAssets removeAllObjects];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.groups.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusable view" forIndexPath:indexPath];
    
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        static NSInteger headerLabelTag = 2468;
        
        UILabel *label = (UILabel *)[view viewWithTag:headerLabelTag];
        
        if (!label) {
            label = [[UILabel alloc] initWithFrame:view.bounds];
            label.tag = headerLabelTag;
            label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:235/255.0f alpha:1.0f];
            [view addSubview:label];
        }
        ALAssetsGroup *group = self.groups[indexPath.section];
        
        // Use any color you want or skip defining it
        UIColor *textColor = [UIColor colorWithWhite:0.35 alpha:1];
        
        NSDictionary *textAttributes = @{NSForegroundColorAttributeName: textColor,
                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:14],
                                         NSTextEffectAttributeName: NSTextEffectLetterpressStyle};
        
        NSAttributedString *attributedString;
        
        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        
        if (groupName) {
            attributedString = [[NSAttributedString alloc] initWithString:groupName attributes:textAttributes];
        }
        label.attributedText = attributedString;
    }
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIColletionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath; {
    ALAsset *asset = self.arrayOfAssets[indexPath.section][indexPath.row];
    CGImageRef imageRef = asset.thumbnail;
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return CGSizeMake((image.size.width*.77), (image.size.height*.77));
}

@end
