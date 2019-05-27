//
//  DynamicCell.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/9.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "DynamicCell.h"

@implementation DynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headerImageView.layer.cornerRadius = 18;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.borderWidth = 0.5;
    self.headerImageView.layer.borderColor = COLOR(245, 245, 245).CGColor;
    
    WEAK(self);
    self.photoView.selectImageBlock = ^(NSInteger item) {
        STRONG(self);
        if (self.selectImageBlock) {
            self.selectImageBlock(self.row, item);
        }
    };
}

- (void)setDynamic:(DynamicModel *)dynamic {
    [self.headerImageView setWebImageWithURL:dynamic.header];
    self.nameLabel.text = dynamic.name;
    self.timeLabel.text = dynamic.time;
    if (dynamic.text.length > 0) {
        self.contentLabel.attributedText = [dynamic.text addLineSpacing:3];
        self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textTopSpace.constant = 12;
    }else {
        self.contentLabel.attributedText = nil;
        self.textTopSpace.constant = 0;
    }
    
    if (dynamic.imageArray.count == 0) {
        self.photoViewHeight.constant = self.photoViewTopSpace.constant = 0;
    }else {
        self.photoView.imageURLArray = dynamic.imageArray;
        CGFloat lineHeight = (SCREEN_WIDTH-24-10)/3;
        NSInteger line = ceil(dynamic.imageArray.count/3.0);
        self.photoViewTopSpace.constant = 12;
        self.photoViewHeight.constant = line*lineHeight+(line-1)*5;
    }
    
    if (dynamic.location.locationName.length > 0) {
        self.locationViewHeight.constant = 42;
        self.locationView.hidden = NO;
        self.locationName.text = dynamic.location.locationName;
    }else {
        self.locationViewHeight.constant = 0;
        self.locationView.hidden = YES;
    }
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UICollectionView class]]) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
