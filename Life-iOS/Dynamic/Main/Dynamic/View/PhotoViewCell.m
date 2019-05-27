//
//  PhotoViewCell.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/14.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "PhotoViewCell.h"

@implementation PhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = COLOR(245, 245, 245);
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        self.imageView = imageView;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.offset(0);
        }];
        self.deleteButton = button;
    }
    return self;
}

@end
