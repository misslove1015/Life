//
//  RegisterVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/8.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "RegisterVC.h"
#import "NetService.h"
#import "User.h"
#import "DynamicVC.h"

@interface RegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) NetService *service;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"注册";
}

- (IBAction)register:(id)sender {
    if ([self.userNameTextField.text trim].length == 0) {
        [self showTextHUD:@"你还未输入账号"];
        return;
    }
    if ([self.passwordTextField.text trim].length == 0) {
        [self showTextHUD:@"你还未输入密码"];
        return;
    }
    
    [self showLoading];
    [self.service registerWithUserName:self.userNameTextField.text password:[self.passwordTextField.text MD5] complete:^(NetResponseModel * _Nonnull responseModel) {
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
