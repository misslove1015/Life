//
//  NoteVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/15.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "NoteVC.h"
#import "NoteCell.h"
#import "NoteDetailVC.h"
#import "NoteModel.h"

static NSString * const identifier = @"cell";

@interface NoteVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NetService *service;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation NoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"笔记";
    [self initPage];
    [self showLoading];
    [self reuqestDataWithIsLoadingMore:NO];
}

- (void)reuqestDataWithIsLoadingMore:(BOOL)isLoadingMore {
    [self.service getNoteListWithIsLoadingMore:isLoadingMore complete:^(NetResponseModel *responseModel) {
        [self hideLoading];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (!isLoadingMore) {
            self.dataArray = [[NSMutableArray alloc]init];
        }
        
        NSArray *array = [NSMutableArray yy_modelArrayWithClass:NoteModel.class json:responseModel.data];
        
        self.tableView.mj_footer.hidden = array.count < pageSize;
        
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }];
}

- (void)addNote {
    NoteDetailVC *detail = [[NoteDetailVC alloc]init];
    detail.hidesBottomBarWhenPushed = YES;
    detail.editSuccessBlock = ^{
        [self reuqestDataWithIsLoadingMore:NO];
    };
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NoteModel *note = self.dataArray[indexPath.row];
    cell.noteModel = note;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoteModel *note = self.dataArray[indexPath.row];
    NoteDetailVC *detail = [[NoteDetailVC alloc]init];
    detail.note = note;
    detail.hidesBottomBarWhenPushed = YES;
    detail.editSuccessBlock = ^{
        [self.tableView reloadData];
    };
    detail.deleteSuccessBlock = ^{
        [self reuqestDataWithIsLoadingMore:NO];
    };
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)initPage {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(NoteCell.class) bundle:nil] forCellReuseIdentifier:identifier];
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reuqestDataWithIsLoadingMore:NO];
    }];
    self.tableView.mj_header = header;
    MJRefreshFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self reuqestDataWithIsLoadingMore:YES];
    }];
    self.tableView.mj_footer = footer;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote)];
    self.navigationItem.rightBarButtonItem = item;
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
