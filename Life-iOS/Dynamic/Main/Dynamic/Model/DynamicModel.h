//
//  DynamicModel.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/9.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface locationModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *address;

@end

@interface DynamicModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, strong) locationModel *location;

@property (nonatomic, copy) NSArray *imageArray;

@end

NS_ASSUME_NONNULL_END
