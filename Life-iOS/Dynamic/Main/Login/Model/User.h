//
//  UserModel.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/8.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *name;

@end


@interface User : NSObject

@property (nonatomic, strong) UserModel *userModel;

+ (User *)defaultUser;
+ (void)updateUser;
+ (void)logout;
+ (BOOL)isLogin;

@end






