//
//  NoteCell.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/17.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell

- (void)setNoteModel:(NoteModel *)noteModel {
    
    if (noteModel.title.length > 0) {
        self.titleLabel.text = noteModel.title;
    }else {
        self.titleLabel.text = noteModel.content;
    }
    
    if (noteModel.content.length > 0) {
        self.contenLabel.text = noteModel.content;
    }else {
        self.contenLabel.text = noteModel.title;
    }
    
    self.timeLabel.text = noteModel.time;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
