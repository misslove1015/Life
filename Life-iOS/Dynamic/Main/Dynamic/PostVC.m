//
//  PostVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/9.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "PostVC.h"
#import "NetSevice.h"

@interface PostVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, strong) NetSevice *service;

@end

@implementation PostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发表";
    [self initPage];
}

- (void)post {
    if ([self.textView.text trim].length == 0) {
        [self showTextHUD:@"你还没有输入文字"];
        return;
    }
    [self.service postWithText:self.textView.text complete:^(NetResponseModel * _Nonnull responseModel) {
        if (responseModel.success) {
            if (self.postSuccessBlock) {
                self.postSuccessBlock();
            }
        }else {
            [self showTextHUD:responseModel.message];
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0;
}

- (void)initPage {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.textView.delegate = self;
}

- (NetSevice *)service {
    if (!_service) {
        _service = [[NetSevice alloc]init];
    }
    return _service;
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
