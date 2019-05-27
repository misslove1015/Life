//
//  PhotoModel.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/17.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
