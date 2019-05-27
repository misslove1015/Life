//
//  UIImageView+MSWebCache.m
//  App
//
//  Created by miss on 2017/10/18.
//  Copyright © 2017年 miss. All rights reserved.
//

#import "UIImageView+MSWebCache.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (MSWebCache)

- (void)setWebImageWithURL:(NSString *)url {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];

}

- (void)setWebImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
}

@end
