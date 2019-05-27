//
//  NetResponseModel.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/8.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "NetResponseModel.h"

@implementation NetResponseModel

- (BOOL)success {
    return self.code == 200;
}

@end
