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

@end

@interface MediaTableViewCell : UITableViewCell

@property (nonatomic, strong) Media *mediaItem;
@property (nonatomic, weak) id <MediaTableViewCellDelegate> delegate;

+ (CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width;

@end
