//
//  MSHTTPSessionManager.m
//  BiuBiu
//
//  Created by miss on 2017/6/2.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import "MSHTTPSessionManager.h"

@implementation MSHTTPSessionManager

+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc]init];
    });
    return manager;
}
@end
