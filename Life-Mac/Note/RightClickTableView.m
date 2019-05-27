//
//  RightClickTableView.m
//  Note
//
//  Created by 郭明亮 on 2019/5/24.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "RightClickTableView.h"

@interface RightClickTableView ()

@property (assign) NSInteger row;

@end

@implementation RightClickTableView

- (NSMenu *)menuForEvent:(NSEvent *)event {
    if (event.type == NSEventTypeRightMouseDown) {
        NSPoint menuPoint = [self convertPoint:[event locationInWindow] fromView:nil];
        NSInteger row = [self rowAtPoint:menuPoint];
        NSIndexSet *indexSet = [self selectedRowIndexes];
        if (row == -1 || [indexSet count] == 0) {
            return nil;
        }

        if ([indexSet containsIndex:row]) {
            self.row = row;
            NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Custom"];
            NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteAction:) keyEquivalent:@""];
            [menu addItem:deleteItem];
            return menu;
        }
        return nil;
    }
    return nil;
}

- (void)deleteAction:(NSMenu *)menu {
    if (self.deleteRow) {
        self.deleteRow(self.row);
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
