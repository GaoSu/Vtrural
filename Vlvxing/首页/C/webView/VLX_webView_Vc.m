//
//  VLX_webView_Vc.m
//  Vlvxing
//
//  Created by grm on 2018/2/23.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_webView_Vc.h"
#import <WebKit/WebKit.h>
#import "ShareBtnView.h"
#import "VLXVHeadModel.h"

@interface VLX_webView_Vc ()<ShareBtnViewDelegate ,UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic ,strong)NSString *contentStrs;
@property (strong,nonatomic)NSString *currentTitle;
@property(nonatomic,weak)UIView * blackView;
@property(nonatomic,weak)ShareBtnView*shareView;

@end

@implementation VLX_webView_Vc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog(@"type什么:%ld",(long)_type);

    [self setNav];
    [self createUI];


}
-(void)createUI
{

//    [self setNav];
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _webView.backgroundColor=[UIColor whiteColor];
    _webView.delegate = self;
    //    _webView.scrollView.scrollEnabled = NO;
    _webView.scrollView.bouncesZoom = NO;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsVerticalScrollIndicator=NO;
    _webView.scrollView.showsHorizontalScrollIndicator=NO;



    NSLog(@"地址轮播::%@",_urlStr);
    NSLog(@"地址类型::%@",NSStringFromClass([_urlStr class]));

    //有空格,将空格去掉
    NSString * meikonggeURL = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];



    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[ZYYCustomTool checkNullWithNSString:meikonggeURL]]]];

//http://app.mtvlx.cn/lvyoushejiaomgr/merchants/gomerchants.json
//http://app.mtvlx.cn/lvyoushejiaomgr/merchants/gomerchants.json

//    NSLog(@"转译之后:::%@",[ZYYCustomTool checkNullWithNSString:_urlStr]);


    [self.view addSubview:_webView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNav{
    self.title=@"详情";
    UIView * rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 22)];
    rightview.backgroundColor=[UIColor whiteColor];

    UIImageView * rightimageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 21.5, 22)];
    rightimageview.image=[UIImage imageNamed:@"share-red"];
    [rightview addSubview:rightimageview];

    UIBarButtonItem * rightBaritem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
    self.navigationItem.rightBarButtonItem=rightBaritem;

    rightview.userInteractionEnabled=YES;
    UITapGestureRecognizer * rightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick2)];
    [rightview addGestureRecognizer:rightTap];


self.view.backgroundColor=[UIColor whiteColor];
//左边按钮
//UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//leftBtn.frame = CGRectMake(0, 0, 20, 20);
//[leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//[leftBtn addTarget:self action:@selector(tapLeftButton) forControlEvents:UIControlEventTouchUpInside];
//UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton)];

}
-(void)rightClick2
{
        [self thirdShareWithUrl:[NSString stringWithFormat:@"%@",_urlStr]];
}

#pragma mark 三方分享调用
-(void)thirdShareWithUrl:(NSString * )url
{
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    UIView*blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.blackView=blackView;
    blackView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3];
    [window addSubview:blackView];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clcikClose)];
    [blackView addGestureRecognizer:tap];
    ShareBtnView*shareView=[[ShareBtnView alloc]init];
    shareView.delegate = self;
    __block VLX_webView_Vc * blockSelf=self;;
    shareView.btnShareBlock=^(NSInteger tag)
    {
        NSString *titleStr;
        NSString *contentStr;
        if(!_contentStrs == nil){
            contentStr = _contentStrs;
        }else{
            contentStr = _currentTitle;
        }
         if (self.type == 4){
            titleStr = _adTitle;
        }

        //           contentStr = @"看世界、V旅行！";
        MyLog(@"share:%ld",tag);
        //555,QQ 556,新浪微博 557,微信 558,朋友圈
        switch (tag) {
            case 555:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_QQ andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:@"http://app.mtvlx.cn/lvyoushejiaomgr/merchants/gomerchants.json"];
                [blockSelf clcikClose];

            }
                break;
            case 556:
            {

                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 557:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 558:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            default:
                break;
        }
    };
    [window addSubview:shareView];
    self.shareView=shareView;

}
#pragma mark--点击关闭按钮
-(void)clcikClose
{
    [self.shareView removeFromSuperview];
    [self .blackView removeFromSuperview];
}

-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
