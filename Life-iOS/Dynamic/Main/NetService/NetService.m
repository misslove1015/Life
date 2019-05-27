//
//  NetService.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/8.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "NetService.h"
#import "MSNetManager.h"

#define loginURL @"login"
#define registerURL @"register"
#define postURL @"post"
#define dynamicListURL @"dynamicList"
#define deleteDynamicURL @"deleteDynamic"
#define editUserInfoURL @"editUserInfo"
#define getQiniuTokenURL @"getQiNiuToken"
#define getUserInfoURL @"getUserInfo"
#define noteListURL @"noteList"
#define editNoteURL @"editNote"
#define deleteNoteURL @"deleteNote"
#define addAlbumURL @"addAlbum"
#define albumListURL @"albumList"
#define editAlbumURL @"editAlbum"
#define setCoverURL @"setCover"
#define deleteAlbumURL @"deleteAlbum"
#define photoListURL @"photoList"
#define addPhotoURL @"addPhoto"
#define deletePhotoURL @"deletePhoto"


@interface NetService ()

@property (nonatomic, strong) NSMutableDictionary *pageDic;

@end

@implementation NetService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

// 登录
- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                 complete:(void(^)(NetResponseModel *responseModel))complete {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:userName forKey:@"userName"];
    [param setValue:password forKey:@"password"];
    [self requestWithURL:loginURL paramDic:param complete:complete];
}

// 注册
- (void)registerWithUserName:(NSString *)userName
                    password:(NSString *)password
                    complete:(void(^)(NetResponseModel *responseModel))complete {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:userName forKey:@"userName"];
    [param setValue:password forKey:@"password"];
    [self requestWithURL:registerURL paramDic:param complete:complete];
}

// 发布动态
- (void)postWithText:(NSString *)text
           longitude:(NSString *)longitude
            latitude:(NSString *)latitude
        locationName:(NSString *)locationName
       imageURLArray:(NSArray<NSString *> *)imageURLArray
            complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:text forKey:@"text"];
    [param setValue:imageURLArray.yy_modelToJSONString forKey:@"images"];
    [param setValue:longitude forKey:@"longitude"];
    [param setValue:latitude forKey:@"latitude"];
    [param setValue:locationName forKey:@"locationName"];
    [self requestWithURL:postURL paramDic:param complete:complete];
}

// 获取动态列表
- (void)getDynamicWithIsLoadingMore:(BOOL)isLoadingMore
                           complete:(void(^)(NetResponseModel *responseModel))complete {
    NSInteger page = [self.pageDic[dynamicListURL] integerValue];
    if (isLoadingMore) {
        page++;
    }else {
        page = 1;
    }
    [self.pageDic setValue:@(page) forKey:dynamicListURL];
    [self requestWithURL:dynamicListURL paramDic:@{@"page":@(page), @"pageSize":@(pageSize)} complete:complete];
}

// 删除动态
- (void)deleteDynamicWithId:(NSString *)dynamicId
                   complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:dynamicId forKey:@"dynamicId"];
    [self requestWithURL:deleteDynamicURL paramDic:param complete:complete];
}

// 修改昵称和头像
- (void)editNameWithName:(NSString *)name
                  header:(NSString *)header
                complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:name forKey:@"name"];
    [param setValue:header forKey:@"header"];
    [self requestWithURL:editUserInfoURL paramDic:param complete:complete];
}

// 获取七牛 Token
- (void)getQiniuTokenWithComplete:(void(^)(NetResponseModel *responseModel))complete {
    [self requestWithURL:getQiniuTokenURL paramDic:nil complete:complete];
}

// 获取用户信息
- (void)getUserInfoWithComplete:(void(^)(NetResponseModel *responseModel))complete {
    [self requestWithURL:getUserInfoURL paramDic:nil complete:complete];
}

// 获取笔记列表
- (void)getNoteListWithIsLoadingMore:(BOOL)isLoadingMore
                            complete:(void(^)(NetResponseModel *responseModel))complete {
    NSInteger page = [self.pageDic[noteListURL] integerValue];
    if (isLoadingMore) {
        page++;
    }else {
        page = 1;
    }
    [self.pageDic setValue:@(page) forKey:noteListURL];
    [self requestWithURL:noteListURL paramDic:@{@"page":@(page), @"pageSize":@(pageSize)} complete:complete];
}

// 编辑笔记
- (void)editNoteWithNoteId:(NSString *)noteId
                     title:(NSString *)title
                   content:(NSString *)content
                  complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:noteId forKey:@"noteId"];
    [param setValue:title forKey:@"title"];
    [param setValue:content forKey:@"content"];
    [self requestWithURL:editNoteURL paramDic:param complete:complete];
}

// 删除笔记
- (void)deleteNoteWithNoteId:(NSString *)noteId
                    complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:noteId forKey:@"noteId"];
    [self requestWithURL:deleteNoteURL paramDic:param complete:complete];
}

// 添加相册
- (void)addAlbumWithName:(NSString *)name
                complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:name forKey:@"name"];
    [self requestWithURL:addAlbumURL paramDic:param complete:complete];
}

// 获取相册列表
- (void)getAlbumListWithIsLoadingMore:(BOOL)isLoadingMore
                             complete:(void(^)(NetResponseModel *responseModel))complete {
    NSInteger page = [self.pageDic[albumListURL] integerValue];
    if (isLoadingMore) {
        page++;
    }else {
        page = 1;
    }
    [self.pageDic setValue:@(page) forKey:albumListURL];
    [self requestWithURL:albumListURL paramDic:@{@"page":@(page), @"pageSize":@(pageSize)} complete:complete];
}

// 编辑相册名字
- (void)editAlbumWithAlbumId:(NSString *)albumId
                        name:(NSString *)name
                    complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:name forKey:@"name"];
    [param setValue:albumId forKey:@"albumId"];
    [self requestWithURL:editAlbumURL paramDic:param complete:complete];
}

// 设置相册封面图
- (void)setCoverWithAlbumId:(NSString *)albumId
                      image:(NSString *)image
                   complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:albumId forKey:@"albumId"];
    [param setValue:image forKey:@"cover"];
    [self requestWithURL:setCoverURL paramDic:param complete:complete];
}

// 删除相册
- (void)deleteAlbumWithAlbumId:(NSString *)AlbumId
                      complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:AlbumId forKey:@"albumId"];
    [self requestWithURL:deleteAlbumURL paramDic:param complete:complete];
}

// 添加照片
- (void)addPhotoWithAlbumId:(NSString *)albumId
                 photoArray:(NSArray *)photoArray
                   complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:albumId forKey:@"albumId"];
    [param setValue:[photoArray yy_modelToJSONString] forKey:@"images"];
    [self requestWithURL:addPhotoURL paramDic:param complete:complete];
}

// 获取照片列表
- (void)getPhotoListWithAlbumId:(NSString *)albumId
                  isLoadingMore:(BOOL)isLoadingMore
                       complete:(void(^)(NetResponseModel *responseModel))complete {
    NSInteger page = [self.pageDic[photoListURL] integerValue];
    if (isLoadingMore) {
        page++;
    }else {
        page = 1;
    }
    [self.pageDic setValue:@(page) forKey:photoListURL];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:albumId forKey:@"albumId"];
    [param setValue:@(page) forKey:@"page"];
    [param setValue:@(pageSize) forKey:@"pageSize"];
    [self requestWithURL:photoListURL paramDic:param complete:complete];
}

// 删除照片
- (void)deletePhotoWithPhotoIdArray:(NSArray *)photoIdArray
                           complete:(void(^)(NetResponseModel *responseModel))complete {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[photoIdArray yy_modelToJSONString] forKey:@"images"];
    [self requestWithURL:deletePhotoURL paramDic:param complete:complete];
}


- (void)requestWithURL:(NSString *)url paramDic:(NSDictionary *)paramDic complete:(void(^)(NetResponseModel *responseModel))complete {
    if (!paramDic) {
        paramDic = @{};
    }
    [MSNetManager POSTWithURL:url parmDic:paramDic complete:^(NSDictionary *dic, NSError *error) {
        NetResponseModel *responseModel = [NetResponseModel yy_modelWithJSON:dic];
        if (complete) {
            complete(responseModel);
        }
    }];
}

@end
