//
//  NoteCell.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/17.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contenLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NoteModel *noteModel;

@end

NS_ASSUME_NONNULL_END
