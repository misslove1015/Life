//
//  NSObject+MSAlert.m
//  App
//
//  Created by miss on 2017/10/18.
//  Copyright © 2017年 miss. All rights reserved.
//

#import "NSObject+MSAlert.h"

@implementation NSObject (MSAlert)

- (void)alertWithTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentAlertController:alert];
}

- (void)alertWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentAlertController:alert];
}

- (void)alertWithTitle:(NSString*)title message:(NSString*)message confirmButtonAction:(void(^)(void))confirmAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (action) {
            confirmAction();
        }
    }]];
    [self presentAlertController:alert];
}

- (void)alertWithTitle:(NSString*)title
               message:(NSString*)message
          confirmTitle:(NSString *)confirmTitle
           cancelTitle:(NSString *)cancelTitle
   confirmButtonAction:(void(^)(void))confirmAction
    cancelButtonAction:(void(^)(void))cancelAction; {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (action) {
                cancelAction();
            }
        }]];
    }
    if (confirmTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            if (action) {
                confirmAction();
            }
        }]];
    }     

    [self presentAlertController:alert];
}

- (void)alertNoCancelWithTitle:(NSString*)title message:(NSString*)message confirmButtonAction:(void(^)(void))confirmAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (action) {
            confirmAction();
        }
    }]];
    [self presentAlertController:alert];
}

- (void)alertWithTitle:(NSString *)title cancelButtonAction:(void(^)(void))cancelAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (action) {
            cancelAction();
        }
    }]];
    [self presentAlertController:alert];
}

- (void)presentAlertController:(UIViewController*)controller {
    UIViewController* rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:controller animated:YES completion:nil];
}

- (void)showTextFiledAlertWithTitle:(NSString*)title
                               text:(NSString *)text
                        placeholder:(NSString*)placeholder
                       confirmTitle:(NSString *)confirmTitle
                        cancelTitle:(NSString *)cancelTitle
                confirmButtonAction:(void(^)(NSString *text))confirmAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        textField.text = text;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (confirmAction) {
            UITextField *textField = alert.textFields.firstObject;
            confirmAction(textField.text);
        }
    }]];
    
    [self presentAlertController:alert];
}

@end
