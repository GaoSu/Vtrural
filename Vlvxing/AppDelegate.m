//
//  AppDelegate.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [UIWindow new];
    //需要设置和导航栏一样的颜色，否则隐藏导航栏时会出现黑色
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setFrame:[UIScreen mainScreen].bounds];
    [self customNavigationBar];
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.window setRootViewController:[CYLTabBarControllerConfig new].tabBarController];
    
//    NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
//    NSString *bandVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLogin"]) {
//        
//        if ([[userDefaults objectForKey:@"FirstLogin"] isEqualToString:bandVersion]) {
//            
//            [self.window setRootViewController:[CYLTabBarControllerConfig new].tabBarController];
//            
//        }else {
//            
////            HDLeadController *leadController = [[HDLeadController alloc]init];
////            self.window.rootViewController = leadController;
//            
//        }
//        
//    }else {
//        
////        HDLeadController *leadController = [[HDLeadController alloc]init];
////        self.window.rootViewController = leadController;
//        
//    }
    return YES;
}
#pragma mark---设置导航栏
- (void)customNavigationBar//设置导航栏
{
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor hexStringToColor:@"#ffffff"]];
    NSDictionary *textAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:19],
                                     NSForegroundColorAttributeName : [UIColor hexStringToColor:@"#313131"],};
    [navigationBarAppearance setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    //去除导航栏黑线
    //    [navigationBarAppearance setShadowImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"dbdbdb"]]];
    
}
#pragma mark

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
