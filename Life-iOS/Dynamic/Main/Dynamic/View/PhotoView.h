//
//  PhotoView.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/14.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PhotoViewType) {
    PhotoViewType_Normal,
    PhotoViewType_Add,
};

NS_ASSUME_NONNULL_BEGIN

@interface PhotoView : UIView

@property (nonatomic, assign) PhotoViewType photoViewType;

@property (nonatomic, copy) NSArray<UIImage *> *imageArray;

@property (nonatomic, copy) NSArray<NSString *> *imageURLArray;

@property (nonatomic, copy) void(^selectImageBlock)(NSInteger item);

@property (nonatomic, copy) void(^addBlock)(void);

@property (nonatomic, copy) void(^deleteBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
