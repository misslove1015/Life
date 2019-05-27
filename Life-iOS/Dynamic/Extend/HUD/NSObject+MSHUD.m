//
//  NSObject+MSHUD.m
//  App
//
//  Created by miss on 2017/10/18.
//  Copyright © 2017年 miss. All rights reserved.
//

#import "NSObject+MSHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation NSObject (MSHUD)

- (void)showTextHUDOnWindow:(NSString *)text {    
    MBProgressHUD *textHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    textHUD.mode = MBProgressHUDModeText;
    textHUD.label.text = text;
    textHUD.label.textColor = [UIColor whiteColor];
    textHUD.margin = 10;
    textHUD.bezelView.color = [UIColor blackColor];
    textHUD.userInteractionEnabled = NO;
    [textHUD showAnimated:YES];
    [textHUD hideAnimated:YES afterDelay:1];
}

- (void)showSectionTitle:(NSString *)title {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
    MBProgressHUD *textHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    textHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    textHUD.mode = MBProgressHUDModeText;
    textHUD.label.text = title;
    textHUD.label.textColor = [UIColor whiteColor];
    textHUD.label.font = [UIFont systemFontOfSize:50];
    textHUD.margin = 10;
    textHUD.minSize = CGSizeMake(80, 80);
    textHUD.bezelView.color = [UIColor colorWithRed:39/255.0 green:184/255.0 blue:242/255.0 alpha:0.8];
    textHUD.bezelView.bounds = CGRectMake(0, 0, 100, 100);
    textHUD.userInteractionEnabled = NO;
    [textHUD showAnimated:YES];
    [textHUD hideAnimated:YES afterDelay:1];
}

- (void)showLoadingOnWindow {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
}

- (void)hideLoadingOnWindow {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
}

@end
