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

// 获取笔记列表
- (void)getNoteListWithComplete:(void(^)(NetResponseModel *responseModel))complete;

// 编辑笔记
- (void)editNoteWithNoteId:(NSString *)noteId
                     title:(NSString *)title
                   content:(NSString *)content
                  complete:(void(^)(NetResponseModel *responseModel))complete;

// 删除笔记
- (void)deleteNoteWithNoteId:(NSString *)noteId
                    complete:(void(^)(NetResponseModel *responseModel))complete;

@end


