//
//  NetResponseModel.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/8.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetResponseModel : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) id data;

@property (nonatomic, assign) BOOL success;

@end

NS_ASSUME_NONNULL_END
