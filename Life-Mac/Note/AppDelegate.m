//
//  AppDelegate.m
//  Note
//
//  Created by 郭明亮 on 2019/5/24.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.mainWindowVC = [[NSStoryboard mainStoryboard] instantiateControllerWithIdentifier:@"main"];
    [self.mainWindowVC.window center];
    [self.mainWindowVC.window orderFront:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self.mainWindowVC.window makeKeyAndOrderFront:nil];
    return YES;
}


@end
