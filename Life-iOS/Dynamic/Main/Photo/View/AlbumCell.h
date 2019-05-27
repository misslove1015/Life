//
//  AlbumCell.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/17.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlbumCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) AlbumModel *albumModel;

@end

NS_ASSUME_NONNULL_END
