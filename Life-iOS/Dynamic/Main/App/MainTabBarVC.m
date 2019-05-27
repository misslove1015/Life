//
//  MainTabBarVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/15.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "MainTabBarVC.h"
#import "DynamicVC.h"
#import "NoteVC.h"
#import "AlbumVC.h"
#import "MineVC.h"

@interface MainTabBarVC ()

@end

@implementation MainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildVCName:[DynamicVC new] title:@"动态" imageName:@"tab_dynamic" selectImageName:@""];
    [self addChildVCName:[NoteVC new] title:@"笔记" imageName:@"tab_note" selectImageName:@""];
    [self addChildVCName:[AlbumVC new] title:@"相册" imageName:@"tab_photo" selectImageName:@""];
    [self addChildVCName:[MineVC new] title:@"我的" imageName:@"tab_mine" selectImageName:@""];
    self.tabBar.unselectedItemTintColor = [UIColor grayColor];

}

- (void)addChildVCName:(UIViewController *)viewController title:(NSString*)title imageName:(NSString*)imageName selectImageName:(NSString*)selectImageName {
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    nav.tabBarItem.title = title;
    UIImage *normalImage = [UIImage imageNamed:imageName];
    nav.tabBarItem.image = normalImage;
    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(-1, 0, 1, 0)];
    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    [self addChildViewController:nav];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
