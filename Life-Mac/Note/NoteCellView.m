//
//  NoteCellView.m
//  Note
//
//  Created by 郭明亮 on 2019/5/24.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "NoteCellView.h"

@implementation NoteCellView


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    self.contentLabel.maximumNumberOfLines = 2;

    // Drawing code here.
}

@end
