//
//  UIViewController+Helper.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/16.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "UIViewController+Helper.h"
#import <objc/runtime.h>

@implementation UIViewController (Helper)

+ (void)load {
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod([self class], @selector(deallocSwizzle));
    method_exchangeImplementations(method1, method2);
}

- (void)deallocSwizzle {
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
    [self deallocSwizzle];
}

@end
