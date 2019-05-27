//
//  LoginVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/8.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "LoginVC.h"
#import "NetService.h"
#import "User.h"
#import "DynamicVC.h"
#import "RegisterVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) NetService *service;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"登录";
    
    if (User.defaultUser.userModel.userName.length > 0) {
        self.userNameTextField.text = User.defaultUser.userModel.userName;
    }
    
}

- (IBAction)login:(id)sender {
    if ([self.userNameTextField.text trim].length == 0) {
        [self showTextHUD:@"你还未输入账号"];
        return;
    }
    if ([self.passwordTextField.text trim].length == 0) {
        [self showTextHUD:@"你还未输入密码"];
        return;
    }
    
    [self showLoading];
    [self.service loginWithUserName:self.userNameTextField.text password:[self.passwordTextField.text MD5] complete:^(NetResponseModel * _Nonnull responseModel) {
        [self hideLoading];
        if (responseModel.success) {
            UserModel *userModel = [UserModel yy_modelWithJSON:responseModel.data];
            [User defaultUser].userModel = userModel;
            [User updateUser];
            [Window homePage];
        }else {
            [self showTextHUD:responseModel.message];
        }
    }];
}

- (IBAction)registerButtonClick:(id)sender {
    [self.navigationController pushViewController:[RegisterVC new] animated:YES];
}

- (IBAction)forgotPassword:(id)sender {
    [self showTextHUD:@"亲，这边建议您重新注册一个呢"];
}

- (NetService *)service {
    if (!_service) {
        _service = [[NetService alloc]init];
    }
    return _service;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
