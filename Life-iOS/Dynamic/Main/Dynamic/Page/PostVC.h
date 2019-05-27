//
//  PostVC.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/9.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostVC : UIViewController

@property (nonatomic, copy) void(^postSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
