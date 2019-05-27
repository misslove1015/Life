//
//  NoteDetailVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/17.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "NoteDetailVC.h"

@interface NoteDetailVC ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) NetService *service;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (nonatomic, strong) UIToolbar *toolBar;

@end

@implementation NoteDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详情";
    [self initPage];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 新建笔记，且没有输入任何文字
    if (self.titleTextField.text.length == 0 &&
        self.textView.text.length == 0 &&
        !self.note) {
        return;
    }
    
    // 没有任何改动
    if ([self.titleTextField.text isEqualToString:self.note.title] &&
        [self.textView.text isEqualToString:self.note.content]) {
        return;
    }

    [self.service editNoteWithNoteId:self.note.id title:self.titleTextField.text content:self.textView.text complete:^(NetResponseModel *responseModel) {
        self.note.title = self.titleTextField.text;
        self.note.content = self.textView.text;
        if (self.editSuccessBlock) {
            self.editSuccessBlock();
        }
    }];

}

- (void)deleteNote {
    [self alertWithTitle:@"确定删除这个笔记吗？" message:nil confirmButtonAction:^{
        [self.service deleteNoteWithNoteId:self.note.id complete:^(NetResponseModel *responseModel) {
            if (responseModel.success) {
                [self showTextHUD:@"删除成功"];
                if (self.deleteSuccessBlock) {
                    self.deleteSuccessBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}

- (void)initPage {
    if (self.note) {
        self.titleTextField.text = self.note.title;
        self.textView.text = self.note.content;
        
        self.titleTextField.inputAccessoryView =
        self.textView.inputAccessoryView = self.toolBar;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(showMore)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    self.textView.textContainerInset = UIEdgeInsetsMake(12, 8, 12, 8);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardWillShow:(NSNotification *)info {
    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomSpace.constant = keyboardBounds.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:[[[info userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)info {
    self.bottomSpace.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:[[[info userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
        [self.view layoutIfNeeded];
    }];
}

- (void)showMore {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除笔记" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteNote];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NetService *)service {
    if (!_service) {
        _service = [[NetService alloc]init];
    }
    return _service;
}

-(UIToolbar *)toolBar{
    if(!_toolBar){
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked)];
        [_toolBar setItems:@[flexibleSpace, doneItem]];
    }
    return _toolBar;
}

- (void)doneClicked {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
