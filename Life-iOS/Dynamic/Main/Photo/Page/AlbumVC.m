//
//  AlbumVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/17.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "AlbumVC.h"
#import "AlbumCell.h"
#import "PhotoVC.h"
#import "AlbumModel.h"

static NSString * const identifier = @"cell";

@interface AlbumVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NetService *service;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"相册";
    [self initPage];
    [self showLoading];
    [self requestDataWithIsLoadingMore:NO];
}

- (void)requestDataWithIsLoadingMore:(BOOL)isLoadingMore {
    [self.service getAlbumListWithIsLoadingMore:isLoadingMore complete:^(NetResponseModel *responseModel) {
        [self hideLoading];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (!isLoadingMore) {
            self.dataArray = [[NSMutableArray alloc]init];
        }
        
        NSArray *array = [NSMutableArray yy_modelArrayWithClass:AlbumModel.class json:responseModel.data];
        
        self.collectionView.mj_footer.hidden = array.count < pageSize;
        
        [self.dataArray addObjectsFromArray:array];
        [self.collectionView reloadData];
    }];
}

- (void)addAlbum {
    WEAK(self);
    [self showTextFiledAlertWithTitle:@"新建相册" text:nil placeholder:@"输入相册名字" confirmTitle:@"确定" cancelTitle:@"取消" confirmButtonAction:^(NSString *text) {
        if (text.trim.length > 0) {
            [self.service addAlbumWithName:text complete:^(NetResponseModel *responseModel) {
                STRONG(self);
                if (responseModel.success) {
                    [self requestDataWithIsLoadingMore:NO];
                }
            }];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    AlbumModel *album = self.dataArray[indexPath.item];
    cell.albumModel = album;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumModel *album = self.dataArray[indexPath.item];
    PhotoVC *vc = [[PhotoVC alloc]init];
    vc.album = album;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    vc.needReloadBlock = ^{
        [self.collectionView reloadData];
    };
    vc.needRefreshBlock = ^{
        [self requestDataWithIsLoadingMore:NO];
    };
}

- (void)initPage {
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlbum)];
    self.navigationItem.rightBarButtonItem = item;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2.0, (SCREEN_WIDTH-30)/2.0+40);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(AlbumCell.class) bundle:nil] forCellWithReuseIdentifier:identifier];
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDataWithIsLoadingMore:NO];
    }];
    self.collectionView.mj_header = header;
    MJRefreshFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self requestDataWithIsLoadingMore:YES];
    }];
    self.collectionView.mj_footer = footer;
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
