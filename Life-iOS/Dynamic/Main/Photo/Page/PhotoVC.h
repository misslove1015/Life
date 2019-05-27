//
//  PhotoVC.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/15.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoVC : UIViewController

@property (nonatomic, strong) AlbumModel *album;
@property (nonatomic, copy) void(^needReloadBlock)(void);
@property (nonatomic, copy) void(^needRefreshBlock)(void);

@end

NS_ASSUME_NONNULL_END
