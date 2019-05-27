//
//  ChangePasswordVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/27.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "NetService.h"
#import "User.h"

@interface ChangePasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *theNewPasswordTextField;

@property (nonatomic, strong) NetService *net;

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改密码";
    self.userNameTextField.text = User.defaultUser.userModel.userName;
}

- (IBAction)submit:(id)sender {
    if ([self.userNameTextField.text trim].length == 0) {
        [self showTextHUD:@"账号不能为空"];
        return;
    }
    if ([self.passwordTextField.text trim].length == 0) {
        [self showTextHUD:@"密码不能为空"];
        return;
    }
    if ([self.theNewPasswordTextField.text trim].length == 0) {
        [self showTextHUD:@"新密码不能为空"];
        return;
    }
    
    [self showLoading];
    [self.net changePasswordWithUserName:self.userNameTextField.text
                                password:[self.passwordTextField.text MD5]
                             newPassword:[self.theNewPasswordTextField.text MD5]
                                complete:^(NetResponseModel *responseModel) {
        [self hideLoading];
        if (responseModel.success) {
            [self showTextHUD:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self showTextHUD:responseModel.message];
        }
    }];
}


- (NetService *)net {
    if (!_net) {
        _net = [[NetService alloc]init];
    }
    return _net;
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
