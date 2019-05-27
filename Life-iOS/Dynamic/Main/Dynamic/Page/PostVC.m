//
//  PostVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/9.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "PostVC.h"
#import "NetService.h"
#import "PhotoView.h"
#import "AJPhotoBrowserViewController.h"
#import "AJPhotoPickerViewController.h"
#import <Qiniu/QiniuSDK.h>
#import "SelectLocationVC.h"

@interface PostVC ()<UITextViewDelegate, AJPhotoPickerProtocol, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet PhotoView *photoView;
@property (nonatomic, strong) NetService *service;
@property (nonatomic, strong) NSMutableArray <UIImage *> *imageArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *imageURLArray;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, assign) BOOL isPosting;

@end

@implementation PostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发布";
    [self initPage];
}

- (void)post {
    if (self.isPosting) return;
    
    if ([self.textView.text trim].length == 0 && self.imageArray.count == 0) {
        [self showTextHUD:@"输入一些文字或添加一张照片"];
        return;
    }
    
    self.isPosting = YES;
    [self showLoading];
    
    if (self.imageArray.count > 0) {
        [self uploadImages:self.imageArray complete:^{
            [self postRequest];
        }];
    }else {
        [self postRequest];
    }

}

- (void)postRequest {
    [self.service postWithText:self.textView.text longitude:[NSString  stringWithFormat:@"%f", self.coordinate.longitude] latitude:[NSString  stringWithFormat:@"%f", self.coordinate.latitude] locationName:self.locationName  imageURLArray:self.imageURLArray  complete:^(NetResponseModel * _Nonnull responseModel) {
        self.isPosting = NO;
        [self hideLoading];
        if (responseModel.success) {
            if (self.postSuccessBlock) {
                self.postSuccessBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self showTextHUD:responseModel.message];
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0;
}

- (IBAction)selectLocation:(id)sender {
    SelectLocationVC *vc = [[SelectLocationVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.selectBlock = ^(NSString * _Nonnull name, CLLocationCoordinate2D coordinate) {
        self.locationName = name;
        self.clearButton.hidden = NO;
        self.coordinate = coordinate;
        [self.locationButton setTitle:name forState:UIControlStateNormal];
    };
}

- (IBAction)clearLocation:(id)sender {
    [self.locationButton setTitle:@" 选择位置" forState:UIControlStateNormal];
    self.clearButton.hidden = YES;
    self.locationName = nil;
}

- (void)initPage {
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsMake(5, 8, 5, 8);
    
    self.photoView.photoViewType = PhotoViewType_Add;
    
    self.imageArray = [[NSMutableArray alloc]init];
    
    WEAK(self);
    self.photoView.addBlock = ^{
        STRONG(self);
        [self openUserPhoto];
    };
    
    self.photoView.deleteBlock = ^(NSInteger index) {
        STRONG(self);
        [self.imageArray removeObjectAtIndex:index];
        self.photoView.imageArray = self.imageArray;
    };
    
    self.photoView.selectImageBlock = ^(NSInteger item) {
        STRONG(self);
        NSMutableArray *dataArray = [NSMutableArray array];
        [self.imageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
            YBImageBrowseCellData *data = [YBImageBrowseCellData new];
            data.imageBlock = ^__kindof UIImage * _Nullable{
                return image;
            };
            [dataArray addObject:data];
        }];
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = dataArray;
        browser.currentIndex = item;
        [browser show];
    };
}

- (void)openUserPhoto{
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = 9-_imageArray.count;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate = self;
    //picker.indexPathsForSelectedItems = _imageArray;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    for (ALAsset *asset in assets) {
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.imageArray addObject:image];
        self.photoView.imageArray = self.imageArray;
    }

}


- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker{
    [self showTextHUD:@"最多选择9张"];
}

- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImagePickerController *cameraUI = [UIImagePickerController new];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
    [self presentViewController: cameraUI animated: YES completion:nil];
}

- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image){
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        
        if (image){
            [self.imageArray addObject:image];
            self.photoView.imageArray = self.imageArray;
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)uploadImages:(NSArray<UIImage *> *)images complete:(void(^)(void))complete {
    self.imageURLArray = [NSMutableArray array];
    for (NSInteger i = 0; i < images.count; i++) {
        [self.service getQiniuTokenWithComplete:^(NetResponseModel *responseModel) {
            NSString *token = responseModel.data[@"token"];
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            NSData *data = UIImageJPEGRepresentation(images[i], 0.5);
            [upManager putData:data
                           key:nil
                         token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          NSLog(@"%@",info.error);
                          if (info.ok) {
                              NSString *url = [NSString stringWithFormat:@"%@/%@",QiNiuURL,resp[@"key"]];
                              NSLog(@"%@", url);
                              [self.imageURLArray addObject:url];
                              if (self.imageURLArray.count == images.count) {
                                  if (complete) {
                                      complete();
                                  }
                              }
                              
                          }else {
                              [self showTextHUD:@"上传失败，请稍后再试"];
                          }
                      } option:nil];
        }];
    }
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
