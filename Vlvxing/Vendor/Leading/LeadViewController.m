//
//  LeadViewController.m
//  lvxingyongche
//
//  Created by Michael on 16/1/8.
//  Copyright © 2016年 handong001. All rights reserved.
//

#import "LeadViewController.h"
#import "CommonScrollView.h"
#import "CommonPageControl.h"
#import "CommonImage.h"
#import "AppDelegate.h"
//#import "XWLoginViewController.h"
//#import "XWRegistController.h"
#import "CYLTabBarControllerConfig.h"
#define BtnHeight   30
#define MyScrollHeigth ScreenSize.height


@interface LeadViewController ()<UIScrollViewDelegate> {
    
    CommonScrollView *myScrollView;
    
    CommonPageControl *myPageControl;
    
    NSArray *imageArray;
}

@end

@implementation LeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    imageArray = @[@"yindao1",@"yindao2",@"yindao3",@"yindao4"];
    
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    [self loadScrollView];
    
//   [self loadPageControl];//原版是有的,现在因为图的原因,不显示小点点

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;
    
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  添加ScrollView
 */
- (void)loadScrollView
{
    myScrollView = [[CommonScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, MyScrollHeigth)];
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    myScrollView.contentSize = CGSizeMake(imageArray.count * ScreenSize.width, ScreenSize.height-100);
    
    for (int i=0; i<imageArray.count; i++)
    {
        //放置图片
        CommonImage *leadImage = [[CommonImage alloc]initWithFrame:CGRectMake(i * ScreenSize.width, 0, ScreenSize.width, MyScrollHeigth) imageName:imageArray[i]];
        [myScrollView addSubview:leadImage];
    
    }
    
//     [self loadButtonView];
//    [self loadButtonView];
}

/**
 *  添加PageControl
 */
-(void)loadPageControl
{
    myPageControl = [[CommonPageControl alloc]initWithFrame:CGRectMake((ScreenSize.width - 120)/2.0, ScreenSize.height - 50, 120, 30)];
    myPageControl.numberOfPages = (int)imageArray.count ;
    [self.view addSubview:myPageControl];
}
/**
 *  添加ButtonView
 */
- (void)loadButtonView
{
    UIButton* buttonViewOne=[[UIButton alloc] initWithFrame:CGRectMake(0, ScreenSizeHeight*2/3, ScreenSizeWith/2, ScreenSizeHeight/3)];
    buttonViewOne.backgroundColor=[UIColor redColor];
    [self.view addSubview:buttonViewOne];
    
    UIButton* buttonViewTwo=[[UIButton alloc] initWithFrame:CGRectMake(ScreenSizeWith/2, ScreenSizeHeight*2/3, ScreenSizeWith/2, ScreenSizeHeight/3)];
    buttonViewTwo.backgroundColor=[UIColor clearColor];
    [self.view addSubview:buttonViewTwo];
    
    [buttonViewOne addTarget:self action:@selector(didLoginButton) forControlEvents:UIControlEventTouchUpInside];
//    [buttonViewTwo addTarget:self action:@selector(didRegistButton:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)didLoginButton{

   

}

/**
 *  UIScrollViewDelegate
 *
 *  @param scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x/scrollView.frame.size.width;
    int pageNumber = offset + .5;
    myPageControl.currentPage = pageNumber;
    if (scrollView.contentOffset.x > scrollView.frame.size.width * (imageArray.count - 1))
    {
        //0x1456c8d50
        //0x1456c4b80
//        CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
        //0x12eec8e00
//        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
//        window.backgroundColor=[UIColor whiteColor];
//        window.rootViewController=tabBarControllerConfig.tabBarController;
//        [window makeKeyAndVisible];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //    appDelegate.window = [UIWindow new];
        //需要设置和导航栏一样的颜色，否则隐藏导航栏时会出现黑色
        [appDelegate.window setBackgroundColor:[UIColor whiteColor]];
        [appDelegate.window setFrame:[UIScreen mainScreen].bounds];
        //        [self customNavigationBar];
        CYLTabBarController *tab = [CYLTabBarControllerConfig new].tabBarController;
        [appDelegate.window setRootViewController:tab];
        appDelegate.mainController=tab;
        
        [appDelegate.window makeKeyAndVisible];
        
        
    }
    
}



//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
//    
//    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
//    window.backgroundColor=[UIColor whiteColor];
//    window.rootViewController=tabBarControllerConfig.tabBarController;
//    [window makeKeyAndVisible];
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
