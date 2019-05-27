//
//  MSNetManager.h
//  Miss
//
//  Created by miss on 17/3/29.
//  Copyright © 2017年 mukr. All rights reserved.
//

// 网络请求

#import <Foundation/Foundation.h>

@interface MSNetManager : NSObject

+ (void)GETWithURL:(NSString *)url
           parmDic:(NSDictionary *)parmDic
          complete:(void(^)(NSDictionary *dic, NSError *error))completeBlock;


+ (void)POSTWithURL:(NSString *)url
            parmDic:(NSDictionary *)parmDic
           complete:(void(^)(NSDictionary *dic, NSError *error))completeBlock;


@end
