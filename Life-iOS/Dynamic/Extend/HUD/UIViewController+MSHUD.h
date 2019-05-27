//
//  UIViewController+MSHUD.h
//  App
//
//  Created by miss on 2017/12/29.
//  Copyright © 2017年 miss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MSHUD)

// 文字HUD
- (void)showTextHUD:(NSString *)text;
- (void)showTextHUDAtSelfView:(NSString *)text;

// 加载HUD
- (void)showLoading;
// 隐藏加载HUD
- (void)hideLoading;
- (void)showLoadingHUDInWindow;
- (void)hideLoadingHUDFromWindow;
@end
