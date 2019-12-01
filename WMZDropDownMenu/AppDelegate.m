//
//  AppDelegate.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/19.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
