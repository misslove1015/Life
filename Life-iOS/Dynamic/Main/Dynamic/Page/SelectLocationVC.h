//
//  SelectLocationVC.h
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/15.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectLocationVC : UIViewController

@property (nonatomic, copy) void(^selectBlock)(NSString *name, CLLocationCoordinate2D coordinate);

@end

NS_ASSUME_NONNULL_END
