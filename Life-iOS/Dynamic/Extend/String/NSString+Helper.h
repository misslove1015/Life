//
//  NSString+Helper.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/9.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Helper)

- (NSString *)MD5;

- (NSString *)trim;

- (NSMutableAttributedString *)addLineSpacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
