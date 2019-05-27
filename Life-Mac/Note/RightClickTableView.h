//
//  RightClickTableView.h
//  Note
//
//  Created by 郭明亮 on 2019/5/24.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface RightClickTableView : NSTableView

@property (copy) void(^deleteRow)(NSInteger row);

@end

NS_ASSUME_NONNULL_END
