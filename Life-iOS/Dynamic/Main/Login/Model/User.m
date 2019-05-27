//
//  UserModel.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/8.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "User.h"

@implementation UserModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

@end


@implementation User

+ (User *)defaultUser {
    static dispatch_once_t onceToken;
    static User *user = nil;
    dispatch_once(&onceToken, ^{
        user = [[User alloc]init];
    });
    return user;
}

- (instancetype)init {
    self = [super init];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    NSError *error;
    UserModel *userModel = [NSKeyedUnarchiver unarchivedObjectOfClass:UserModel.class fromData:data error:&error];
    self.userModel = userModel;
    return self;
}

+ (void)updateUser {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[User defaultUser].userModel requiringSecureCoding:YES error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userModel"];
}

+ (void)logout {
    [User defaultUser].userModel.id = nil;
    [self updateUser];
}

+ (BOOL)isLogin {
    return [User defaultUser].userModel.id;
}

@end

