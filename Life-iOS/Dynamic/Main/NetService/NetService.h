//
//  NetService.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/8.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetResponseModel.h"

@interface NetService : NSObject

// 登录
- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                 complete:(void(^)(NetResponseModel *responseModel))complete;

// 注册
- (void)registerWithUserName:(NSString *)userName
                    password:(NSString *)password
                    complete:(void(^)(NetResponseModel *responseModel))complete;

// 更改密码
- (void)changePasswordWithUserName:(NSString *)userName
                          password:(NSString *)password
                       newPassword:(NSString *)newpassword
                          complete:(void(^)(NetResponseModel *responseModel))complete;

// 发布动态
- (void)postWithText:(NSString *)text
           longitude:(NSString *)longitude
            latitude:(NSString *)latitude
        locationName:(NSString *)locationName
       imageURLArray:(NSArray<NSString *> *)imageURLArray
            complete:(void(^)(NetResponseModel *responseModel))complete;

// 获取动态列表
- (void)getDynamicWithIsLoadingMore:(BOOL)isLoadingMore
                           complete:(void(^)(NetResponseModel *responseModel))complete;

// 删除动态
- (void)deleteDynamicWithId:(NSString *)dynamicId
                   complete:(void(^)(NetResponseModel *responseModel))complete;

// 修改头像和昵称
- (void)editNameWithName:(NSString *)name
                  header:(NSString *)header
                complete:(void(^)(NetResponseModel *responseModel))complete;

// 获取七牛 Token
- (void)getQiniuTokenWithComplete:(void(^)(NetResponseModel *responseModel))complete;

// 获取用户信息
- (void)getUserInfoWithComplete:(void(^)(NetResponseModel *responseModel))complete;

// 获取笔记列表
- (void)getNoteListWithIsLoadingMore:(BOOL)isLoadingMore
                            complete:(void(^)(NetResponseModel *responseModel))complete;

// 编辑笔记
- (void)editNoteWithNoteId:(NSString *)noteId
                     title:(NSString *)title
                   content:(NSString *)content
                  complete:(void(^)(NetResponseModel *responseModel))complete;

// 删除笔记
- (void)deleteNoteWithNoteId:(NSString *)noteId
                    complete:(void(^)(NetResponseModel *responseModel))complete;

// 添加相册
- (void)addAlbumWithName:(NSString *)name
               complete:(void(^)(NetResponseModel *responseModel))complete;

// 获取相册列表
- (void)getAlbumListWithIsLoadingMore:(BOOL)isLoadingMore
                            complete:(void(^)(NetResponseModel *responseModel))complete;

// 编辑相册名字
- (void)editAlbumWithAlbumId:(NSString *)albumId
                        name:(NSString *)name
                   complete:(void(^)(NetResponseModel *responseModel))complete;

// 设置相册封面图
- (void)setCoverWithAlbumId:(NSString *)albumId
                      image:(NSString *)image
                   complete:(void(^)(NetResponseModel *responseModel))complete;

// 删除相册
- (void)deleteAlbumWithAlbumId:(NSString *)AlbumId
                    complete:(void(^)(NetResponseModel *responseModel))complete;

// 添加照片
- (void)addPhotoWithAlbumId:(NSString *)albumId
                 photoArray:(NSArray *)photoArray
                   complete:(void(^)(NetResponseModel *responseModel))complete;

// 获取照片列表
- (void)getPhotoListWithAlbumId:(NSString *)albumId
                  isLoadingMore:(BOOL)isLoadingMore
                       complete:(void(^)(NetResponseModel *responseModel))complete;

// 删除照片
- (void)deletePhotoWithPhotoIdArray:(NSArray *)photoIdArray
                           complete:(void(^)(NetResponseModel *responseModel))complete;

@end


