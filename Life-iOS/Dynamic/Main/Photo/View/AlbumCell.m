//
//  AlbumCell.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/17.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAlbumModel:(AlbumModel *)albumModel {
    [self.coverimageView setWebImageWithURL:[NSString stringWithFormat:@"%@?imageView2/2/w/300", albumModel.cover]];
    self.nameLabel.text = albumModel.name;
}

@end
