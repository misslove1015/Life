//
//  MSNetManager.m
//  Miss
//
//  Created by miss on 17/3/29.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import "MSNetManager.h"
#import "MSHTTPSessionManager.h"

#define AppURL @"http://www.guomingliang.cn:8080"

@implementation MSNetManager

+ (void)GETWithURL:(NSString *)url
           parmDic:(NSDictionary *)parmDic
          complete:(void(^)(NSDictionary *, NSError *))completeBlock {
    
    AFHTTPSessionManager *manager = [MSHTTPSessionManager sharedManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [manager.requestSerializer setValue:@"29" forHTTPHeaderField:@"userId"];
    
    url = [NSString stringWithFormat:@"%@/%@", AppURL, url];
#ifdef DEBUG
    NSLog(@"%@\n%@", url,parmDic);
#endif
    [manager GET:url parameters:parmDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
#ifdef DEBUG
        NSLog(@"%@", responseDic);
#endif
        if (completeBlock) {
            completeBlock(responseDic, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completeBlock) {
            completeBlock(nil, error);
        }
        NSLog(@"%@",error);
    }];
    
}

+ (void)POSTWithURL:(NSString *)url
            parmDic:(NSDictionary *)parmDic
           complete:(void (^)(NSDictionary *, NSError *))completeBlock {
    AFHTTPSessionManager *manager = [MSHTTPSessionManager sharedManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"29" forHTTPHeaderField:@"userId"];
    
    url = [NSString stringWithFormat:@"%@/%@", AppURL, url];
#ifdef DEBUG
    NSLog(@"%@ \n %@", url, parmDic);
#endif
    [manager POST:url parameters:parmDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (completeBlock) {
            completeBlock(responseDic, nil);
        }
#ifdef DEBUG
        NSLog(@"%@", responseDic);
#endif
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completeBlock) {
            completeBlock(nil, error);
        }
        NSLog(@"%@", error);
    }];
}
@end
