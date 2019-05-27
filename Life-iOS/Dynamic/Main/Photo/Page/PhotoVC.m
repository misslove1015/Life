//
//  PhotoVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/15.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "PhotoVC.h"
#import "PhotoModel.h"
#import "PhotoCell.h"
#import "AJPhotoBrowserViewController.h"
#import "AJPhotoPickerViewController.h"
#import <Qiniu/QiniuSDK.h>

static NSString * const identifier = @"cell";

@interface PhotoVC () <UICollectionViewDelegate, UICollectionViewDataSource, AJPhotoPickerProtocol, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NetService *service;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *imageURLArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteViewBottomSpace;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, assign) BOOL isChangeCover;
@property (nonatomic, assign) BOOL isUploading;

@end

@implementation PhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.album.name;
    [self initPage];
    [self showLoading];
    [self requestDataWithIsLoadingMore:NO];
}

- (void)requestDataWithIsLoadingMore:(BOOL)isLoadingMore {
    [self.service getPhotoListWithAlbumId:self.album.id isLoadingMore:isLoadingMore  complete:^(NetResponseModel *responseModel) {
        
        [self hideLoading];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (!isLoadingMore) {
            self.dataArray = [[NSMutableArray alloc]init];
        }
        
        NSArray *array = [NSMutableArray yy_modelArrayWithClass:PhotoModel.class json:responseModel.data];
        
        self.collectionView.mj_footer.hidden = array.count < 20;
        
        [self.dataArray addObjectsFromArray:array];
        [self.collectionView reloadData];
    }];
}

// 添加照片
- (void)addPhotos:(NSArray<UIImage *> *)photos {
    if (photos.count == 0) return;
    [self showLoading];
    self.isUploading = YES;
    WEAK(self);
    [self uploadImages:photos complete:^{
        [self.service addPhotoWithAlbumId:self.album.id photoArray:self.imageURLArray complete:^(NetResponseModel *responseModel) {
            STRONG(self);
            self.isUploading = NO;
            [self requestDataWithIsLoadingMore:NO];
            if (self.album.cover.length == 0) {
                if (self.needRefreshBlock) {
                    self.needRefreshBlock();
                }
            }
        }];
    }];
}

// 删除照片
- (void)deletePhotos:(NSArray<NSString *> *)photos {
    if (photos.count == 0) return;
    [self.service deletePhotoWithPhotoIdArray:photos complete:^(NetResponseModel *responseModel) {
        if (responseModel.success) {
            [self requestDataWithIsLoadingMore:NO];
        }
    }];
}

// 修改相册名
- (void)changeAlbumName {
    WEAK(self);
    [self showTextFiledAlertWithTitle:@"修改相册名" text:self.album.name placeholder:@"输入新的相册名" confirmTitle:@"确定" cancelTitle:@"取消" confirmButtonAction:^(NSString *text) {
        STRONG(self);
        if (text.trim.length == 0 || [text isEqualToString:self.album.name]) return;
            
        [self.service editAlbumWithAlbumId:self.album.id name:text complete:^(NetResponseModel *responseModel) {
            if (responseModel.success) {
                self.album.name = text;
                self.navigationItem.title = text;
                if (self.needReloadBlock) {
                    self.needReloadBlock();
                }
            }
        }];
    }];
}

// 删除相册
- (void)deleteAlbum {
    WEAK(self);
    [self alertWithTitle:@"确定删除这个相册吗？" message:@"删除后，相册内照片也会一并删除\n此操作不可撤回" confirmButtonAction:^{
        STRONG(self);
        [self.service deleteAlbumWithAlbumId:self.album.id complete:^(NetResponseModel *responseModel) {
            if (responseModel.success) {
                [self showTextHUD:@"删除成功"];
                if (self.needRefreshBlock) {
                    self.needRefreshBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}

- (void)changeCoverWithImage:(NSString *)image {
    [self showLoading];
    WEAK(self);
    [self.service setCoverWithAlbumId:self.album.id image:image complete:^(NetResponseModel *responseModel) {
        STRONG(self);
        self.isChangeCover = NO;
        [self.collectionView reloadData];
        [self hideLoading];
        if (responseModel.success) {
            self.album.cover = image;
            [self showTextHUD:@"更改成功"];
            if (self.needReloadBlock) {
                self.needReloadBlock();
            }
        }
    }];
}

- (void)changeCover {
    [self.dataArray enumerateObjectsUsingBlock:^(PhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = NO;
    }];
    self.isChangeCover = YES;
    [self.collectionView reloadData];
}

- (void)deletePhoto {
    [self.dataArray enumerateObjectsUsingBlock:^(PhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = NO;
    }];
    [self chanceIsDelete:YES];
    self.deleteViewBottomSpace.constant = 0;
}

- (IBAction)deleteViewCancel:(id)sender {
    [self chanceIsDelete:NO];
    [self hideDeleteView];
}

- (IBAction)deleteViewSubmit:(id)sender {
    [self chanceIsDelete:NO];
    [self hideDeleteView];
    
    NSMutableArray *deleteArray = [[NSMutableArray alloc]init];
    [self.dataArray enumerateObjectsUsingBlock:^(PhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            [deleteArray addObject:obj.id];
        }
    }];
    [self deletePhotos:deleteArray];
}

- (void)hideDeleteView {
    self.deleteViewBottomSpace.constant = -(44+BOTTOM_HEIGHT);
}

- (void)chanceIsDelete:(BOOL)isDelete {
    self.isDelete = isDelete;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    PhotoModel *photo = self.dataArray[indexPath.item];
    [cell setPhoto:photo showSelectImage:(self.isDelete || self.isChangeCover)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDelete) {
        PhotoModel *photo = self.dataArray[indexPath.item];
        photo.isSelect = !photo.isSelect;
        [self.collectionView reloadData];
    }else if (self.isChangeCover) {
        PhotoModel *photo = self.dataArray[indexPath.item];
        photo.isSelect = YES;
        [self.collectionView reloadData];
        [self changeCoverWithImage:photo.url];
    }else {
        NSMutableArray *dataArray = [NSMutableArray array];
        [self.dataArray enumerateObjectsUsingBlock:^(PhotoModel * _Nonnull photo, NSUInteger idx, BOOL * _Nonnull stop) {
            YBImageBrowseCellData *data = [YBImageBrowseCellData new];
            data.url = [NSURL URLWithString:photo.url];
            [dataArray addObject:data];
        }];
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = dataArray;
        browser.currentIndex = indexPath.item;
        [browser show];
    }
}

- (void)initPage {
    self.deleteViewHeight.constant = 40+BOTTOM_HEIGHT;
    self.deleteViewBottomSpace.constant = -(44+BOTTOM_HEIGHT);

    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(showMore)];
    self.navigationItem.rightBarButtonItem = item;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 3;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-6)/3.0, (SCREEN_WIDTH-6)/3.0);
    layout.estimatedItemSize = CGSizeMake(0, 0);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(PhotoCell.class) bundle:nil] forCellWithReuseIdentifier:identifier];
    WEAK(self);
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRONG(self);
        [self requestDataWithIsLoadingMore:NO];
    }];
    self.collectionView.mj_header = header;
    MJRefreshFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        STRONG(self);
        [self requestDataWithIsLoadingMore:YES];
    }];
    self.collectionView.mj_footer = footer;
}

- (void)showMore {
    if (self.isUploading) return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"添加照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addPhoto];
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deletePhoto];
    }];
    UIAlertAction *coverAction = [UIAlertAction actionWithTitle:@"更改封面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeCover];
    }];
    UIAlertAction *editNameAction = [UIAlertAction actionWithTitle:@"修改相册名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeAlbumName];
    }];
    UIAlertAction *deleteAlbumAction = [UIAlertAction actionWithTitle:@"删除相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteAlbum];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:addAction];
    [alert addAction:deleteAction];
    [alert addAction:coverAction];
    [alert addAction:editNameAction];
    [alert addAction:deleteAlbumAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addPhoto {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = 99;
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
    NSMutableArray *imageArray = [NSMutableArray array];
    for (ALAsset *asset in assets) {
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imageArray addObject:image];
    }
    [self addPhotos:imageArray];
}

- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker{
    [self showTextHUD:@"一次最多上传99张"];
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
            NSArray *array = @[image];
            [self uploadImages:array complete:^{
                [self requestDataWithIsLoadingMore:NO];
            }];
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
                          if (info.ok) {
                              NSString *url = [NSString stringWithFormat:@"%@/%@",QiNiuURL,resp[@"key"]];
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
