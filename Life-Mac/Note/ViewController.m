//
//  ViewController.m
//  Note
//
//  Created by 郭明亮 on 2019/5/24.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "ViewController.h"
#import "NetService.h"
#import <YYModel/YYModel.h>
#import "NoteModel.h"
#import "NoteCellView.h"
#import "RightClickTableView.h"

@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet RightClickTableView *tableView;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSProgressIndicator *indicatorView;
@property (strong) NetService *net;
@property (strong) NSArray *dataArray;
@property (strong) NoteModel *note;
@property (assign) NSInteger lastSelectRow;
@property (assign) BOOL isNeedSelect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    self.textView.textColor = [NSColor textColor];
    self.textView.font = [NSFont systemFontOfSize:16];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;
    self.textView.defaultParagraphStyle = style;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.textView.textContainerInset = NSMakeSize(10, 10);
    self.net = [[NetService alloc]init];
    [self getNoteList];
    __weak typeof(self) weakSelf = self;
    self.tableView.deleteRow = ^(NSInteger row) {
        [weakSelf deleteRow:row];
    };
    
}

- (void)viewWillAppear {
    [super viewWillAppear];
    self.view.window.restorable = NO;
    [self.view.window setContentSize:NSMakeSize(800, 600)];

}

- (void)getNoteList {
    [self.indicatorView startAnimation:nil];
    [self.net getNoteListWithComplete:^(NetResponseModel *responseModel) {
        [self.indicatorView stopAnimation:nil];
        self.dataArray = [NSArray yy_modelArrayWithClass:NoteModel.class json:responseModel.data];
        [self.tableView reloadData];
        if (self.dataArray.count == 0) return;
        if (self.isNeedSelect) {
            self.isNeedSelect = NO;
            if (self.lastSelectRow < self.dataArray.count) {
                [self seletRow:self.lastSelectRow];
            }else {
                [self seletRow:0];
            }
        }else {
            if (!self.note.id) {
                [self seletRow:0];
            }
        }
    }];
}

- (void)seletRow:(NSInteger)row {
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:false];
    [self tableView:self.tableView shouldSelectRow:row];
}

- (IBAction)refresh:(id)sender {
    self.isNeedSelect = YES;
    [self getNoteList];
}

- (IBAction)newNote:(id)sender {
    self.note = nil;
    self.titleLabel.stringValue = @"";
    self.textView.string = @"";

    [self.titleLabel becomeFirstResponder];
}

- (IBAction)save:(id)sender {
    if (self.titleLabel.stringValue.length == 0 &&
        self.textView.string.length == 0) return;
    
    [self saveRequest];
    if (self.note.id) {
        self.isNeedSelect = YES;
    }
}

- (void)deleteRow:(NSInteger)row {
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:false];
    [self tableView:self.tableView shouldSelectRow:row];
    
    NSAlert * alert = [[NSAlert alloc]init];
    alert.messageText = @"确定删除这个笔记吗？";
    alert.alertStyle = NSAlertStyleCritical;
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
        if(returnCode == NSAlertFirstButtonReturn){
            NoteModel *note = self.dataArray[row];
            [self.net deleteNoteWithNoteId:note.id complete:^(NetResponseModel *responseModel) {
                self.note = nil;
                [self getNoteList];
            }];
        }else if (returnCode == NSAlertSecondButtonReturn){
            NSLog(@"取消");
        }else{
            NSLog(@"All Other return code %ld",(long)returnCode);
        }
    }];
}

- (void)saveRequest {
    [self.indicatorView startAnimation:nil];
    [self.net editNoteWithNoteId:self.note.id title:self.titleLabel.stringValue content:self.textView.string complete:^(NetResponseModel *responseModel) {
        [self.indicatorView stopAnimation:nil];
        [self getNoteList];
    }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.dataArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NoteCellView *cell = [tableView makeViewWithIdentifier:@"cell" owner:self];
    NoteModel *note = self.dataArray[row];
    cell.titleLabel.stringValue = note.title;
    cell.contentLabel.stringValue = note.content;
    cell.timeLabel.stringValue = note.time;
    return cell;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    self.titleLabel.editable = YES;
    NoteModel *note = self.dataArray[row];
    self.titleLabel.stringValue = note.title;
    self.textView.string = note.content;
    self.note = note;
    self.lastSelectRow = row;
    return YES;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
