//
//  UIImage+Exit.h
//  o2o
//
//  Created by fanweapp on 14-7-14.
//
//

// 压缩图片

#import <UIKit/UIKit.h>

@interface UIImage (Exit)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
