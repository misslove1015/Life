//
//  PhotoCell.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/17.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPhoto:(PhotoModel *)photo showSelectImage:(BOOL)showSelectImage {
    [self.imageView setWebImageWithURL:[NSString stringWithFormat:@"%@?imageView2/2/w/300", photo.url]];
    self.selectImageView.image = [UIImage imageNamed:photo.isSelect?@"select":@"no_select"];
    self.selectImageView.hidden = !showSelectImage;
}

@end
