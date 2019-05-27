//
//  UIButton+MSWebCache.m
//  App
//
//  Created by miss on 2017/10/18.
//  Copyright © 2017年 miss. All rights reserved.
//

#import "UIButton+MSWebCache.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation UIButton (MSWebCache)

- (void)setWebImageWithURL:(NSString *)url {
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:nil];

}

- (void)setWebImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage {
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:placeholderImage];
}

- (void)setImageWithWebImageURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage {
    [self sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
}

@end
