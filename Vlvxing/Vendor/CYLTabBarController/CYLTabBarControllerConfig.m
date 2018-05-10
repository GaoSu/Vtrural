//
//  CYLTabBarControllerConfig.m
//  CYLTabBarController
//
//  v1.6.5 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//
#import "CYLTabBarControllerConfig.h"

@interface CYLBaseNavigationController : UINavigationController
@end

@implementation CYLBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 0);
        btn.tintColor = [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = leftItem;
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end

//View Controllers


#import "VLXHomeController.h"
#import "VLXCourseViewController.h"
#import "VLXRecordViewController.h"//暂时废弃
#import "VLX_CommunityViewController.h"//社交(社区 交流) //将轨迹换成社交模块

#import "VLX_NewCommunityVC.h"//新社交
#import "VLXMineViewController.h"

@interface CYLTabBarControllerConfig ()

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation CYLTabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                                   tabBarItemsAttributes:self.tabBarItemsAttributesForController];
        [self customizeTabBarAppearance:tabBarController];
        
        tabBarController.tabBar.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight - 49 , K_SCREEN_WIDTH , 49);
        _tabBarController = tabBarController;
    }



    return _tabBarController;
}

- (NSArray *)viewControllers {
   
    //首页
        VLXHomeController *firstViewController = [[VLXHomeController alloc] init];
        CYLBaseNavigationController *firstNavigationController = [[CYLBaseNavigationController alloc]
                                                                  initWithRootViewController:firstViewController];
        
        //记录
        VLXCourseViewController  *secondViewController = [[VLXCourseViewController alloc] init];
        CYLBaseNavigationController *secondNavigationController = [[CYLBaseNavigationController alloc]
                                                                   initWithRootViewController:secondViewController];
    
    //旅途,注掉
//    //废弃轨迹模块↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//        VLXRecordViewController *FourthViewController = [[VLXRecordViewController alloc] init];
//        CYLBaseNavigationController *FourthNavigationController = [[CYLBaseNavigationController alloc]initWithRootViewController:FourthViewController];
//    //废弃轨迹模块↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    //新增社交模块↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//    VLX_CommunityViewController * FOURTH_Viewcontroller = [[VLX_CommunityViewController alloc]init];
//    CYLBaseNavigationController *FourthNavigationController = [[CYLBaseNavigationController alloc]initWithRootViewController:FOURTH_Viewcontroller];
    //新增社交模块↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    //New新增社交模块↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    VLX_NewCommunityVC * fourthVC = [[VLX_NewCommunityVC alloc]init];
    CYLBaseNavigationController *FourthNavigationController = [[CYLBaseNavigationController alloc]initWithRootViewController:fourthVC];
    //New新增社交模块↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
    
    //我的
        VLXMineViewController *fifthViewController = [[VLXMineViewController alloc] init];
        CYLBaseNavigationController *fifthNavigationController = [[CYLBaseNavigationController alloc]
                                                                  initWithRootViewController:fifthViewController];
        //    fifthNavigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"ff6666"];
        /**
         * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
         * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
         * 更推荐后一种做法。
         */
        //tabBarController.imageInsets = UIEdgeInsetsMake(4.5, 0, -4.5, 0);
        //tabBarController.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
    
        NSArray *viewControllers = @[
                                     firstNavigationController,
                                     secondNavigationController,
//
                                     FourthNavigationController,
                                     fifthNavigationController
                                     ];
        return viewControllers;
   
    
}

- (NSArray *)tabBarItemsAttributesForController {
 
        NSDictionary *firstTabBarItemsAttributes = @{
                                                     CYLTabBarItemTitle : @"首页",
                                                     CYLTabBarItemImage : @"ios首页@2x",
                                                     CYLTabBarItemSelectedImage : @"ios首页点击@2x",
                                                     };
        
        NSDictionary *secondTabBarItemsAttributes = @{
                                                      CYLTabBarItemTitle : @"记录",
                                                      CYLTabBarItemImage : @"ios记录@2x",
                                                      CYLTabBarItemSelectedImage : @"ios记录点击@2x",
                                                      };
    
        NSDictionary *FourthTabBarItemsAttributes = @{
                                                      CYLTabBarItemTitle : @"社区",
                                                      CYLTabBarItemImage : @"ios社区@2x",
                                                      CYLTabBarItemSelectedImage : @"ios社区点击@2x",
                                                      };
    
        NSDictionary *fifthTabBarItemsAttributes = @{
                                                     CYLTabBarItemTitle : @"我的",
                                                     CYLTabBarItemImage : @"ios我的@2x",
                                                     CYLTabBarItemSelectedImage : @"ios我的点击@2x"
                                                     };
        NSArray *tabBarItemsAttributes = @[
                                           firstTabBarItemsAttributes,
                                           secondTabBarItemsAttributes,
//
                                           FourthTabBarItemsAttributes,
                                           fifthTabBarItemsAttributes
                                           ];
        return tabBarItemsAttributes;
  
    
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {

    // Customize UITabBar height
    // 自定义 TabBar 高度
//     tabBarController.tabBarHeight = 49.f;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#8E8E93"];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"ff6666"];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    
    NSMutableDictionary *attrnor = [NSMutableDictionary dictionary];
    // 设置item字体
    attrnor[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [tabBarItem setTitleTextAttributes:attrnor forState:UIControlStateNormal];

    
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@""]];
    
    // set the bar background image
    // 设置背景图片
    // UITabBar *tabBarAppearance = [UITabBar appearance];
    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    UITabBarController *tabBarController = [self cyl_tabBarController] ?: [[UITabBarController alloc] init];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor redColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
