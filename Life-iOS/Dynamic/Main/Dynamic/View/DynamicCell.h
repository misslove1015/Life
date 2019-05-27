//
//  DynamicCell.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/9.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"
#import "PhotoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet PhotoView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTopSpace;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (nonatomic, strong) DynamicModel *dynamic;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy) void(^selectImageBlock)(NSInteger row, NSInteger index);


@end

NS_ASSUME_NONNULL_END
