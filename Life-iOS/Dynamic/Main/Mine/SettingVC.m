//
//  SettingVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/24.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "SettingVC.h"
#import <WebKit/WebKit.h>
#import "User.h"
#import "ChangePasswordVC.h"

@interface SettingVC ()

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置";
    [self getFolderSize];

}

- (IBAction)logout:(id)sender {
    [self alertWithTitle:@"确认退出吗？" message:nil confirmButtonAction:^{
        [User logout];
        [Window login];
    }];
    
}

- (IBAction)changePassword:(id)sender {
    [self.navigationController pushViewController:[ChangePasswordVC new] animated:YES];
}

- (IBAction)clearCache:(id)sender {
    self.cacheLabel.text = @"正在清理";
    [self.activityIndicatorView startAnimating];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                
            }
        }
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cacheLabel.text = [NSString stringWithFormat:@"0.00M"];
                [self showTextHUD:@"清除成功"];
                [self.activityIndicatorView stopAnimating];
            });
        }];
    });
}

- (void)getFolderSize{
    [self.activityIndicatorView startAnimating];

    __block float allSize = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //获取Cache目录
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            allSize += [self folderSizeAtPath:path];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicatorView stopAnimating];
            self.cacheLabel.text = [NSString stringWithFormat:@"%.2fM",allSize];
        });
        
    });
}

- (long long)fileSizeAtPath:(NSString*)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (float)folderSizeAtPath:(NSString*)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
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
