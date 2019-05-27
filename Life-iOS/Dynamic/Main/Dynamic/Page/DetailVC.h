//
//  DetailVC.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/10.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailVC : UIViewController

@property (nonatomic, strong) DynamicModel *dynamic;
@property (nonatomic, copy) void(^deleteSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
