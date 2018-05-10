//
//  VLXRouteDetailVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/24.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRouteDetailVC.h"
#import "VLXRouteDetailChildVC.h"
#import "VLXRouteJudgeChildVC.h"
#import "ShareBtnView.h"
#import "VLXHomeRecommandModel.h"

#import <WebKit/WebKit.h>//为了使用WKWebView
@interface VLXRouteDetailVC ()<UIScrollViewDelegate,ShareBtnViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *rightView;
@property(nonatomic,weak)UIView * blackView;
@property(nonatomic,weak)ShareBtnView *shareView;
@property (nonatomic,strong)WKWebView * KWwebvw;
@end

@implementation VLXRouteDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self loadData];
}
#pragma mark---数据
-(void)loadData
{
    if ([_biaoshi isEqualToString:@"2"]) {
        [self createNav];
        NSLog(@"url:::::%@",_url);

        _KWwebvw = [[WKWebView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-64)];

        NSURL *url = [NSURL URLWithString:_url];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        NSLog(@"request:%@~~url:%@",request,url);
        //创建NSURLRequest
        [_KWwebvw loadRequest:request];//加载

        [self.view addSubview:_KWwebvw];

    }else{
    [self creaetUI];
    }
}
#pragma mark
#pragma mark---视图
-(void)creaetUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNav];
    [self createScrollView];
}
-(void)createNav
{
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;
    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton:)];

    //中间
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-80*2, 44)];
    self.navigationItem.titleView=titleView;
    NSArray *titleArray=@[@"详情",@"评价"];
    CGFloat width=CGRectGetWidth(titleView.frame)/2;
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(width*i, 0, width, 44);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:19];
        if (i==0) {
            [btn setTitleColor:orange_color forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor hexStringToColor:@"#313131"] forState:UIControlStateNormal];
        }
        btn.tag=100+i;
        [btn addTarget:self action:@selector(NavItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
    }
    _line=[[UIView alloc] initWithFrame:CGRectMake((width-18)/2, 44-2, 18, 2)];
    _line.backgroundColor=orange_color;
    [titleView addSubview:_line];
    //右边
    //右边按钮
    UIView * rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 22)];
    rightview.backgroundColor=[UIColor whiteColor];
    
    UIImageView * rightimageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 21.5, 22)];
    rightimageview.image=[UIImage imageNamed:@"share-red"];
    [rightview addSubview:rightimageview];
    
    UIBarButtonItem * rightBaritem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
    self.navigationItem.rightBarButtonItem=rightBaritem;
    
    rightview.userInteractionEnabled=YES;
    UITapGestureRecognizer * rightTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick3)];
    [rightview addGestureRecognizer:rightTap];
    _rightView=rightview;
}

-(void)createScrollView
{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    
    _scrollView.contentSize=CGSizeMake(2*kScreenWidth, CGRectGetHeight(_scrollView.frame));
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.bounces=NO;
    [self.view addSubview:_scrollView];
    //详情
    VLXRouteDetailChildVC *detailVC=[[VLXRouteDetailChildVC alloc] init];
    detailVC.travelproductID=_travelproductID;
    detailVC.view.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    if ([_biaoshi isEqualToString:@"2"]) {
        [_scrollView addSubview:_KWwebvw];
//        [self addChildViewController:detailVC];
    }else{
        [_scrollView addSubview:detailVC.view];
        [self addChildViewController:detailVC];
    }
    //评价
    VLXRouteJudgeChildVC *judgeVC=[[VLXRouteJudgeChildVC alloc] init];
    judgeVC.productId=_travelproductID;
    judgeVC.view.frame=CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    [_scrollView addSubview:judgeVC.view];
    [self addChildViewController:judgeVC];

}
#pragma mark
#pragma mark---事件
#pragma mark 三方分享调用
-(void)thirdShareWithUrl:(NSString * )url
{
    NSLog(@"_adpic:%@",_adpic);
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    UIView*blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.blackView=blackView;
    blackView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.3];
    [window addSubview:blackView];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clcikClose)];
    [blackView addGestureRecognizer:tap];
    ShareBtnView*shareView=[[ShareBtnView alloc]init];
    shareView.delegate = self;
    __block VLXRouteDetailVC * blockSelf=self;;
    shareView.btnShareBlock=^(NSInteger tag)
    {
        
        NSString *titleStr ;
        NSString *contentStr;
        NSString * imgStr=[NSString stringWithFormat:@"%@",_adpic];//_adpic;
        if ([NSString checkForNull:_detailModel.productname]) { // 为空
            titleStr = @"旅行";
            contentStr = @"看世界、V旅行！";
            
        }else{
            titleStr = _detailModel.productname;
            contentStr = _detailModel.context;
            NSLog(@"%@~~~~~~~~~%@",titleStr,contentStr);
        }
        MyLog(@"share:%ld",tag);
        //555,QQ 556,新浪微博 557,微信 558,朋友圈
        switch (tag) {
            case 555:
            {
//                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_QQ andThumbURL:@"http://img3.2345.com/toolsimg/baike/collect/sheying/73b2150ajw1e6wsbsp5lbj20hs0hs3zs.jpg" andTitle:titleStr andDesc:contentStr andWebPageUrl:url];

                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_QQ andThumbURL:imgStr andTitle:titleStr andDesc:contentStr andWebPageUrl:url];


                [blockSelf clcikClose];
                
            }
                break;
            case 556:
            {
                
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina andThumbURL:imgStr andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 557:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession andThumbURL:imgStr andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
                [blockSelf clcikClose];
            }
                break;
            case 558:
            {
                [ShareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine andThumbURL:imgStr andTitle:titleStr andDesc:contentStr andWebPageUrl:url];
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

-(void)rightClick3
{
    if ([_biaoshi isEqualToString:@"2"]) {
        [self thirdShareWithUrl: [NSString stringWithFormat:@"%@", _url]];
    }
    else{
    [self thirdShareWithUrl:[[NSString stringWithFormat:@"%@/shareurl/farmstayscheduleshare.json?travelProductId=%@",ftpPath,_travelproductID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)NavItemClicked:(UIButton *)sender
{
    CGFloat width=(kScreenWidth-80*2)/2;
    CGFloat margin=(width-18)/2;
    UIButton *leftBtn=[self.navigationItem.titleView viewWithTag:100];
    UIButton *rightBtn=[self.navigationItem.titleView viewWithTag:101];
    if (sender.tag-100==0) {
        [leftBtn setTitleColor:orange_color forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor hexStringToColor:@"#313131"] forState:UIControlStateNormal];
        _rightView.hidden=NO;
    }else if (sender.tag-100==1)
    {
        [leftBtn setTitleColor:[UIColor hexStringToColor:@"#313131"] forState:UIControlStateNormal];
        [rightBtn setTitleColor:orange_color forState:UIControlStateNormal];
        _rightView.hidden=YES;
    }
    [UIView animateWithDuration:0.28 animations:^{
        _line.frame=CGRectMake((sender.tag-100)*width+margin, _line.frame.origin.y, _line.frame.size.width, _line.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    //切换界面
    NSInteger index=sender.tag-100;
    [self.scrollView setContentOffset:CGPointMake(index*kScreenWidth, 0) animated:YES];
    //
    NSLog(@"%ld",sender.tag);
}
#pragma mark
#pragma mark---scrollView delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"EndDragging: %@",NSStringFromCGPoint(scrollView.contentOffset));
    CGFloat width=(kScreenWidth-80*2)/2;
    CGFloat margin=(width-18)/2;
    NSInteger index= scrollView.contentOffset.x/kScreenWidth;//序号
    //改变nav
    UIButton *leftBtn=[self.navigationItem.titleView viewWithTag:100];
    UIButton *rightBtn=[self.navigationItem.titleView viewWithTag:101];
    if (index==0) {
        [leftBtn setTitleColor:orange_color forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor hexStringToColor:@"#313131"] forState:UIControlStateNormal];
    }else if (index==1)
    {
        [leftBtn setTitleColor:[UIColor hexStringToColor:@"#313131"] forState:UIControlStateNormal];
        [rightBtn setTitleColor:orange_color forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.28 animations:^{
        _line.frame=CGRectMake(index*width+margin, _line.frame.origin.y, _line.frame.size.width, _line.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark
#pragma mark---delegate
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
