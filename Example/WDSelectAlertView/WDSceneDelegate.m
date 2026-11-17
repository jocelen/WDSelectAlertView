//
//  WDSceneDelegate.m
//  WDSelectAlertView_Example
//

#import "WDSceneDelegate.h"
#import "WDViewController.h"

@implementation WDSceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[WDViewController alloc] init]];
    window.rootViewController = nav;
    self.window = window;
    [window makeKeyAndVisible];
}

@end
