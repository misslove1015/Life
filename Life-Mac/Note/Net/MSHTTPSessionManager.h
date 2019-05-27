//
//  MSHTTPSessionManager.h
//  BiuBiu
//
//  Created by miss on 2017/6/2.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

@interface MSHTTPSessionManager : AFHTTPSessionManager

+ (AFHTTPSessionManager *)sharedManager;

@end
