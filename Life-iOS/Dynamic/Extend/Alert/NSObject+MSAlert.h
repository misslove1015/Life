//
//  NSObject+MSAlert.h
//  App
//
//  Created by miss on 2017/10/18.
//  Copyright © 2017年 miss. All rights reserved.
//

/**
 * 提示框
 */

#import <Foundation/Foundation.h>

@interface NSObject (MSAlert)

- (void)alertWithTitle:(NSString *)title;

- (void)alertWithTitle:(NSString*)title message:(NSString*)message;

- (void)alertWithTitle:(NSString*)title message:(NSString*)message confirmButtonAction:(void(^)(void))confirmAction;

- (void)alertWithTitle:(NSString*)title
               message:(NSString*)message
          confirmTitle:(NSString *)confirmTitle
           cancelTitle:(NSString *)cancelTitle
   confirmButtonAction:(void(^)(void))confirmAction
    cancelButtonAction:(void(^)(void))cancelAction;

- (void)alertNoCancelWithTitle:(NSString*)title message:(NSString*)message confirmButtonAction:(void(^)(void))confirmAction;

- (void)alertWithTitle:(NSString *)title cancelButtonAction:(void(^)(void))cancelAction;

- (void)showTextFiledAlertWithTitle:(NSString*)title
                               text:(NSString *)text
                        placeholder:(NSString*)placeholder
                       confirmTitle:(NSString *)confirmTitle
                        cancelTitle:(NSString *)cancelTitle
                confirmButtonAction:(void(^)(NSString *text))confirmAction;

@end
