//
//  DetailVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/10.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "DetailVC.h"
#import "NetService.h"
#import "PhotoView.h"
#import "MapVC.h"

@interface DetailVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet PhotoView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewTopSpace;

@property (nonatomic, strong) NetService *service;

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详情";
    [self setSubviews];
}

- (void)setSubviews {
    self.headerImageView.layer.cornerRadius = 18;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.borderWidth = 0.5;
    self.headerImageView.layer.borderColor = COLOR(245, 245, 245).CGColor;
 
    [self.headerImageView setWebImageWithURL:self.dynamic.header];
    self.nameLabel.text = self.dynamic.name;
    self.timeLabel.text = self.dynamic.time;
    if (self.dynamic.text.length > 0) {
        self.contentLabel.attributedText = [self.dynamic.text addLineSpacing:3];
        self.textTopSpace.constant = 12;
    }else {
        self.contentLabel.attributedText = nil;
        self.textTopSpace.constant = 0;
    }
    
    if (self.dynamic.imageArray.count == 0) {
        self.photoViewHeight.constant = self.photoViewTopSpace.constant = 0;
    }else {
        self.photoView.imageURLArray = self.dynamic.imageArray;
        CGFloat lineHeight = (SCREEN_WIDTH-24-10)/3;
        NSInteger line = ceil(self.dynamic.imageArray.count/3.0);
        self.photoViewTopSpace.constant = 12;
        self.photoViewHeight.constant = line*lineHeight+(line-1)*5;
    }
    
    if (self.dynamic.location.locationName.length > 0) {
        self.locationView.hidden = NO;
        self.locationLabel.text = self.dynamic.location.locationName;
    }else {
        self.locationView.hidden = YES;
    }
      
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(showMore)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    WEAK(self);
    self.photoView.selectImageBlock = ^(NSInteger item) {
        STRONG(self);
        NSMutableArray *dataArray = [NSMutableArray array];
        [self.dynamic.imageArray enumerateObjectsUsingBlock:^(NSString * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
            YBImageBrowseCellData *data = [YBImageBrowseCellData new];
            data.url = [NSURL URLWithString:url];
            [dataArray addObject:data];
        }];
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = dataArray;
        browser.currentIndex = item;
        [browser show];
    };
}

- (void)showMore {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除动态" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self delete];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)delete {
    [self alertWithTitle:@"确认删除此动态吗？" message:nil confirmButtonAction:^{
        [self.service deleteDynamicWithId:self.dynamic.id complete:^(NetResponseModel * _Nonnull responseModel) {
            if (responseModel.success) {
                if (self.deleteSuccessBlock) {
                    self.deleteSuccessBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self showTextHUD:responseModel.message];
        }];
    }];
}

- (IBAction)showMap:(id)sender {
    MapVC *vc = [[MapVC alloc]init];
    vc.locationModel = self.dynamic.location;
    [self.navigationController pushViewController:vc animated:YES];
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
