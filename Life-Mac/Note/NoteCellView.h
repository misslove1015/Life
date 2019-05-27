//
//  NoteCellView.h
//  Note
//
//  Created by 郭明亮 on 2019/5/24.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoteCellView : NSTableCellView

@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *contentLabel;
@property (weak) IBOutlet NSTextField *timeLabel;

@end

NS_ASSUME_NONNULL_END
