//
//  AppDelegate+customInit.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/16.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "AppDelegate+customInit.h"
#import "LeadViewController.h"
@implementation AppDelegate (customInit)
- (void)customRootViewController
{
    NSString *saveVersionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    NSString *curVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    self.window = [UIWindow new];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setFrame:[UIScreen mainScreen].bounds];
    
    
    [self customNavigationBar];
    
    if (saveVersionStr && [saveVersionStr isEqualToString:curVersionStr])
    {
        [self setRootViewController];
    }
    else
    {
        [self setGuidePic];
    }
    
    [self.window makeKeyAndVisible];
}
#pragma mark--设置引导页
-(void)setGuidePic
{
    //获取当前版本号
    NSString *curVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:curVersionStr forKey:@"version"];
    
    LeadViewController *leader = [[LeadViewController alloc] init];
    [self.window setRootViewController:leader];
    [self.window makeKeyAndVisible];
    
}
#pragma mark--设置rootViewController
-(void)setRootViewController
{
    CYLTabBarController *tbc = [CYLTabBarControllerConfig new].tabBarController;
    [self.window setRootViewController:tbc];
    self.mainController = tbc;
    
    //   [self requestGuangGaoList];
}
- (void)customNavigationBar
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
-(void)applicationWillEnterForeground:(UIApplication *)application
{
    NSString *saveVersionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    NSString *curVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (saveVersionStr && [saveVersionStr isEqualToString:curVersionStr])
    {
        // [self requestGuangGaoList];
    }
    
}
@end
