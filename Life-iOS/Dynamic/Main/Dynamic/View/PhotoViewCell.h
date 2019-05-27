//
//  PhotoViewCell.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/14.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoViewCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *deleteButton;

@end

NS_ASSUME_NONNULL_END
