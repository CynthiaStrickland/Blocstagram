//
//  MediaTableViewCell.h
//  
//
//  Created by Cynthia Whitlatch on 5/18/15.
//
//

#import <UIKit/UIKit.h>

@class Media, MediaTableViewCell;

@protocol MediaTableViewCellDelegate <NSObject>

-(void) cell:(MediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView;
-(void) cell:(MediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView;

@end

@interface MediaTableViewCell : UITableViewCell

@property (nonatomic, strong) Media *mediaItem;
@property (nonatomic, weak) id <MediaTableViewCellDelegate> delegate;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

+ (CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width;

@end
