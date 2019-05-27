//
//  UIViewController+MSHUD.m
//  App
//
//  Created by miss on 2017/12/29.
//  Copyright © 2017年 miss. All rights reserved.
//

#import "UIViewController+MSHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIViewController (MSHUD)

- (void)showTextHUD:(NSString *)text {
    MBProgressHUD *textHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    textHUD.mode = MBProgressHUDModeText;
    textHUD.label.text = text;
    textHUD.label.textColor = [UIColor whiteColor];
    textHUD.margin = 10;
    textHUD.bezelView.color = [UIColor blackColor];
    textHUD.userInteractionEnabled = NO;
    [textHUD showAnimated:YES];
    [textHUD hideAnimated:YES afterDelay:1.5];
}

- (void)showTextHUDAtSelfView:(NSString *)text {
    MBProgressHUD *textHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    textHUD.mode = MBProgressHUDModeText;
    textHUD.label.text = text;
    textHUD.label.textColor = [UIColor whiteColor];
    textHUD.margin = 10;
    textHUD.bezelView.color = [UIColor blackColor];
    textHUD.userInteractionEnabled = NO;
    [textHUD showAnimated:YES];
    [textHUD hideAnimated:YES afterDelay:1.5];
}

- (void)showLoading {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideLoading {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)showLoadingHUDInWindow {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 38; i++) {
        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"jiazaizhong_000%ld",i]]];
    }
    imageView.animationImages = array;
    imageView.animationDuration = array.count*0.04;
    [imageView startAnimating];
    hud.customView = imageView;
    hud.square = YES;
    hud.userInteractionEnabled = NO;
    hud.bezelView.color = [UIColor whiteColor];
}

- (void)hideLoadingHUDFromWindow {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
}


@end
