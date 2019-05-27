//
//  NoteDetailVC.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/17.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteDetailVC : UIViewController

@property (nonatomic, strong) NoteModel *note;
@property (nonatomic, copy) void(^editSuccessBlock)(void);
@property (nonatomic, copy) void(^deleteSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
