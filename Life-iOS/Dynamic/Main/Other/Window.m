//
//  Window.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/9.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "Window.h"
#import "MainTabBarVC.h"
#import "LoginVC.h"

@implementation Window

+ (void)homePage {
    UIApplication.sharedApplication.delegate.window.rootViewController = [MainTabBarVC new];
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:UIApplication.sharedApplication.delegate.window cache:NO];
    }];
}

+ (void)login {
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[LoginVC new]];
    UIApplication.sharedApplication.delegate.window.rootViewController = nav;
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:UIApplication.sharedApplication.delegate.window cache:NO];
    }];
}

@end
