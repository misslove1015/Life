//
//  MineVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/9.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "MineVC.h"
#import "User.h"
#import "NetService.h"
#import "User.h"
#import <Qiniu/QiniuSDK.h>
#import "UIImage+Exit.h"
#import <Qiniu/QiniuSDK.h>
#import "MSWebViewController.h"
#import "SettingVC.h"

@interface MineVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic, strong) NetService *service;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的";
    [self setSubviewData];
    [self getUserInfo];
}

- (void)getUserInfo {
    [self.service getUserInfoWithComplete:^(NetResponseModel *responseModel) {
        if (responseModel.success) {
            UserModel *userModel = [UserModel yy_modelWithJSON:responseModel.data];
            [User defaultUser].userModel = userModel;
            [User updateUser];
            [self setSubviewData];
        }
    }];
}

- (void)setSubviewData {
    UserModel *user = User.defaultUser.userModel;
    
    self.nameTextField.text = user.name;
    self.headerButton.layer.cornerRadius = 50;
    self.headerButton.layer.masksToBounds = YES;
    self.headerButton.layer.borderWidth = 0.5;
    self.headerButton.layer.borderColor = COLOR(220, 220, 220).CGColor;
    [self.headerButton setWebImageWithURL:user.header];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setting {
    SettingVC *vc = [[SettingVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)webView:(id)sender {
    MSWebViewController *web = [[MSWebViewController alloc]init];
    web.titleString = @"Life";
    web.url = @"http://www.guomingliang.cn";
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}


- (IBAction)nameEditingEnd:(id)sender {
    [self editName:self.nameTextField.text header:nil];
}

- (void)editName:(NSString *)name header:(NSString *)header {
    [self.service editNameWithName:name header:header complete:^(NetResponseModel * _Nonnull responseModel) {
        if (responseModel.success) {
            if (name) {
                User.defaultUser.userModel.name = name;
                [User updateUser];
            }
            if (header) {
                User.defaultUser.userModel.header = header;
                [User updateUser];
            }
            
            if (self.editSuccessBlock) {
                self.editSuccessBlock();
            }
        }else {
            [self showTextHUD:responseModel.message];
        }
    }];
}

- (IBAction)headerButtonClick:(UIButton *)sender {
    [self changeHeaderImage];
}

- (void)changeHeaderImage {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePictureWithIsCamera:YES];
    }];
    UIAlertAction *womanAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePictureWithIsCamera:NO];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:manAction];
    [actionSheet addAction:womanAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)takePictureWithIsCamera:(BOOL)isCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if (isCamera) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        }
    }else {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            picker.delegate = self;
        }
    }

    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image){
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        
        if (image){
            //设置image的尺寸
            CGSize imagesize = image.size;
            imagesize.height = 300;
            imagesize.width = 300;
            //对图片大小进行压缩--
            image = [image imageByScalingAndCroppingForSize:imagesize];
            [self.headerButton setBackgroundImage:image forState:UIControlStateNormal];
            [self uploadToQiniu];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)uploadToQiniu {
    [self.service getQiniuTokenWithComplete:^(NetResponseModel *responseModel) {
        NSString *token = responseModel.data[@"token"];
        [self uploadImageWithToken:token];
    }];
}

- (void)uploadImageWithToken:(NSString *)token {
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *data = UIImagePNGRepresentation(self.headerButton.currentBackgroundImage);
    [upManager putData:data
                   key:nil
                 token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"%@",info.error);
                  if (info.ok) {
                      NSString *url = [NSString stringWithFormat:@"%@/%@",QiNiuURL,resp[@"key"]];
                      NSLog(@"%@", url);
                      [self editName:nil header:url];
                  }else {
                      [self showTextHUD:@"上传失败，请稍后再试"];
                  }
              } option:nil];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (NetService *)service {
    if (!_service) {
        _service = [[NetService alloc]init];
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
