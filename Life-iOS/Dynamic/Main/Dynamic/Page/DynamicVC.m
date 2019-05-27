//
//  DynamicVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/8.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "DynamicVC.h"
#import "MineVC.h"
#import "PostVC.h"
#import "DynamicCell.h"
#import "NetService.h"
#import "DynamicModel.h"
#import "DetailVC.h"
#import "MapVC.h"

static NSString * const identifier = @"cell";

@interface DynamicVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NetService *service;

@end

@implementation DynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"动态";
    [self initPage];
    [self showLoading];
    [self reuqestDataWithIsLoadingMore:NO];

}

- (void)reuqestDataWithIsLoadingMore:(BOOL)isLoadingMore {
    [self.service getDynamicWithIsLoadingMore:isLoadingMore complete:^(NetResponseModel * _Nonnull responseModel) {
        [self hideLoading];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (!isLoadingMore) {
            self.dataArray = [[NSMutableArray alloc]init];
        }
        
        NSArray *array = [NSMutableArray yy_modelArrayWithClass:DynamicModel.class json:responseModel.data];
        
        self.tableView.mj_footer.hidden = array.count < pageSize;
        
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.locationButton.tag = indexPath.row;
    [cell.locationButton addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
    DynamicModel *dynamic = self.dataArray[indexPath.row];
    cell.dynamic = dynamic;
    cell.row = indexPath.row;
    WEAK(self);
    cell.selectImageBlock = ^(NSInteger row, NSInteger index) {
        STRONG(self);
        [self showBigImageWithRow:row index:index];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DynamicModel *dynamic = self.dataArray[indexPath.row];
    DetailVC *detail = [[DetailVC alloc]init];
    detail.dynamic = dynamic;
    detail.deleteSuccessBlock = ^{
        [self reuqestDataWithIsLoadingMore:NO];
    };
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)showMap:(UIButton *)button {
    DynamicModel *dynamic = self.dataArray[button.tag];
    MapVC *vc = [[MapVC alloc]init];
    vc.locationModel = dynamic.location;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showBigImageWithRow:(NSInteger)row index:(NSInteger)index {
    DynamicModel *dynamic = self.dataArray[row];
    NSMutableArray *dataArray = [NSMutableArray array];
    [dynamic.imageArray enumerateObjectsUsingBlock:^(NSString * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
        YBImageBrowseCellData *data = [YBImageBrowseCellData new];
        data.url = [NSURL URLWithString:url];
        [dataArray addObject:data];
    }];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = dataArray;
    browser.currentIndex = index;
    [browser show];
}

- (void)initPage {
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_mine"] style:UIBarButtonItemStylePlain target:self action:@selector(goToMine)];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToPost)];
    self.navigationItem.rightBarButtonItem = rightItem; 

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(DynamicCell.class) bundle:nil] forCellReuseIdentifier:identifier];
    WEAK(self);
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRONG(self);
        [self reuqestDataWithIsLoadingMore:NO];
    }];
    self.tableView.mj_header = header;
    MJRefreshFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        STRONG(self);
        [self reuqestDataWithIsLoadingMore:YES];
    }];
    self.tableView.mj_footer = footer;
}

- (void)goToMine {
    MineVC *mine = [[MineVC alloc]init];
    mine.editSuccessBlock = ^{
        [self reuqestDataWithIsLoadingMore:NO];
    };
    [self.navigationController pushViewController:mine animated:YES];
}

- (void)goToPost {
    PostVC *post = [[PostVC alloc]init];
    post.postSuccessBlock = ^{
        [self reuqestDataWithIsLoadingMore:NO];
    };
    post.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:post animated:YES];
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
