//
//  UIButton+MSWebCache.h
//  App
//
//  Created by miss on 2017/10/18.
//  Copyright © 2017年 miss. All rights reserved.
//

/**
 * UIButton设置网络图片
 * 基于SDWebImage
 */

#import <UIKit/UIKit.h>

@interface UIButton (MSWebCache)

// 设置网络图片，并自动设置占位图片
- (void)setWebImageWithURL:(NSString *)url;

// 设置网络图片，使用自定义的占位图片
- (void)setWebImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

- (void)setImageWithWebImageURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

@end
