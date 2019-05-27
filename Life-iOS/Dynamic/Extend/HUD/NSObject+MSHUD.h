//
//  NSObject+MSHUD.h
//  App
//
//  Created by miss on 2017/10/18.
//  Copyright © 2017年 miss. All rights reserved.
//

/**
 * 透明提示层
 * 基于MBProgressHUD
 */

#import <UIKit/UIKit.h>

@interface NSObject (MSHUD)

// 文字HUD
- (void)showTextHUDOnWindow:(NSString *)text;

// tableView索引点击HUD
- (void)showSectionTitle:(NSString *)title;

// 加载HUD
- (void)showLoadingOnWindow;
// 隐藏加载HUD
- (void)hideLoadingOnWindow;

@end
