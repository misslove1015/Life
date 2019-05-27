//
//  NetService.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/8.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "NetService.h"
#import "MSNetManager.h"
#import <YYModel/YYModel.h>

#define noteListURL @"noteList"
#define editNoteURL @"editNote"
#define deleteNoteURL @"deleteNote"

@implementation NetService

// 获取笔记列表
- (void)getNoteListWithComplete:(void(^)(NetResponseModel *responseModel))complete {
    [self requestWithURL:noteListURL paramDic:@{@"page":@(1), @"pageSize":@(999)} complete:complete];
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
