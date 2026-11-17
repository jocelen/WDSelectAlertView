//
//  WDAppDelegate.m
//  WDSelectAlertView
//
//  Created by jocelen on 04/16/2021.
//  Copyright (c) 2021 jocelen. All rights reserved.
//

#import "WDAppDelegate.h"
#import "WDSceneDelegate.h"

@implementation WDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

#pragma mark - UISceneSession Lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application
configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                              options:(UISceneConnectionOptions *)options {
    UISceneConfiguration *config = [[UISceneConfiguration alloc] initWithName:@"Default Configuration"
                                                                  sessionRole:connectingSceneSession.role];
    config.delegateClass = [WDSceneDelegate class];
    return config;
}

@end
