//
//  VLXHomeController.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXHomeController.h"
#import "VLXHomeHeaderCell.h"
#import "VLXHomeHotCell.h"
#import "VLXHomeRecommandCell.h"
#import "VLXHomeSelectHeaderView.h"
#import "VLXHomeNearByVC.h"
#import "VLXSearchVC.h"
#import "VLXDomesticVC.h"
#import "VLXOutSideVC.h"
#import "VLXCustomTripTableViewVC.h"
#import "VLXUserCarVC.h"
#import "VLXHotDestinationVC.h"
#import "VLXTopNewsVC.h"
#import "VLXMessageCenterVC.h"//消息中心
#import "VLXRouteDetailVC.h"

#import "VLX_TicketViewController.h"//飞机票


//model
#import "VLXHomeAdsModel.h"
#import "VLXVHeadModel.h"
#import "VLXHomeHotModel.h"
#import "VLXHomeRecommandModel.h"
#import "VLXCityChooseVC.h"//城市列表
#import "VLXFindPalaceVC.h"//发现景点
#import "VLXWebViewVC.h"

#import "VLX_webView_Vc.h"///////////////////


#import "JWLaunchAd.h"//新增启动页广告,无缓存直接显示版本


#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
@interface VLXHomeController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,TitleButtonNoDataViewDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong)SDCycleScrollView *adScrollView;//广告轮播图
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)VLXHomeSelectHeaderView *selectHeaderView;
@property(nonatomic,strong)UILabel *cityLab;
@property(nonatomic,strong)UILabel *messageLab;//未读消息个数 用于nav
@property(nonatomic,strong)VLXHomeAdsModel *adsModel;//广告轮播图数据
@property(nonatomic,strong)VLXVHeadModel *vHeadModel;//v头条数据
@property(nonatomic,strong)VLXHomeHotModel *hotModel;//热门目的地数据
@property(nonatomic,strong)VLXHomeRecommandModel *recommandModel;//当季游玩 热门推荐 数据
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; // 存放当季游玩 热门推荐数据
@property(nonatomic,strong)TitleButtonNoDataView *nodateView;
@property(nonatomic,assign)NSInteger recommandType;//1 当季游玩 2 热门推荐
@property(nonatomic,strong)CLLocationManager *locationmanager;
@property(nonatomic,strong)NSMutableArray * AD_TitleArray;//广告标题数组


@property (nonatomic, strong)NSString *imgUrlString;//广告的地址

@end

@implementation VLXHomeController
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}
-(void)dealloc
{
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCity" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoTifGuanggao:) name:@"qidongyeguanggao" object:nil];

    if ([NSString getDefaultToken]) {//如果登录
        [self loadMessageCount];
        [self loadVHeadData];
    }else
    {
        _messageLab.text=@"0";
    }
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToChangeCity:) name:@"changeCity" object:nil];




}
-(void)notifyToChangeCity:(NSNotification *)notify
{
    _cityLab.text=[NSString getCity];
}
//广告的启动图
-(void)NoTifGuanggao:(NSNotification * )notifff{
    NSLog(@"广告的地址通知%@",notifff.userInfo[@"adpicture"]);

    NSString * url = notifff.userInfo[@"adpicture"];

    [JWLaunchAd initImageWithAttribute:3.5 showSkipType:SkipShowTypeAnimation setLaunchAd:^(JWLaunchAd *launchAd) {
        __block JWLaunchAd *weakSelf = launchAd;

        //如果选择 SkipShowTypeAnimation 需要设置动画跳过按钮的属性
        //  3.异步加载图片完成回调(设置图片尺寸)
        weakSelf.launchAdViewFrame = CGRectMake(0, -ScreenHeight+49, ScreenWidth, ScreenHeight);
        [self.tabBarController.tabBar addSubview:weakSelf];
        UIImageView * imgvvw = [[UIImageView alloc]init];//WithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        imgvvw.image = [UIImage imageNamed:@"750x1334.png"];
//        [weakSelf setLaunchAdImgView:imgvvw];
        [weakSelf setAnimationSkipWithAttribute:[UIColor lightGrayColor] lineWidth:3.0 backgroundColor:nil textColor:nil];
///Users/grm/Desktop/壁纸/ac3fa22e8c6ab8207f30404e8d572bec.jpg

//        [launchAd setLaunchAdImgView:];

        [launchAd setWebImageWithURL:url options:JWWebImageDefault result:^(UIImage *image, NSURL *url) {

//            //  3.异步加载图片完成回调(设置图片尺寸)
            weakSelf.launchAdViewFrame = CGRectMake(0, -ScreenHeight+49, ScreenWidth, ScreenHeight);
//
            [self.tabBarController.tabBar addSubview:weakSelf];
        } adClickBlock:^{
            //  4.点击广告回调
//            NSString *url = @"https://www.baidu.com";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];
    }];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    _AD_TitleArray = [NSMutableArray array];
    // Do any additional setup after loading the view.


    NSLog(@"userid到底是啥A%@",[NSString getDefaultUser]);
    NSLog(@"userid到底是啥B%@",[NSString getAlias]);


    //初始化
    _currentPage=1;
    _recommandType=1;
    _dataArr=[NSMutableArray array];
    //定位
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        self.locationmanager = [[CLLocationManager alloc] init];
        [self.locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [self.locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        self.locationmanager.delegate = self;
    }
    __block VLXHomeController *blockSelf=self;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];

    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        
            NSLog(@"纬度:%f 精度:%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            //保存经纬度
            [defaults setObject:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude] forKey:@"latitude"];
            [defaults setObject:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude] forKey:@"longtitude"];
       
    } withCity:^(NSString *addressString) {

        NSLog(@"城市:%@",addressString);
        NSRange range=[addressString rangeOfString:@"市"];
#warning 没有“市”此处会崩溃，需要处理
        NSString *dingweiStr;
        // 如果range的位置大于城市名称就退出方法
        if(range.location >= addressString.length) {
           dingweiStr=addressString; 
        }else{
            dingweiStr=[addressString substringToIndex:range.location];
        }
        
        //        NSRange range=[result.addressDetail.city rangeOfString:@"市"];
        //        self.DWCity=[result.addressDetail.city substringToIndex:range.location];
//        NSString*s=[NSString stringWithFormat:@"当前城市  %@  ",dingweiStr];
        if (![NSString checkForNull:addressString]) {
//            //保存城市名称
            [defaults setObject:[ZYYCustomTool checkNullWithNSString:dingweiStr] forKey:@"city"];
            _cityLab.text=addressString;
            [blockSelf getAreaIDWithCity:dingweiStr];
        }
        
    }];

    [self createUI];
    [self loadData];
}
#pragma mark---数据
-(void)getAreaIDWithCity:(NSString *)city//根据地区获取areaid
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];


    dic[@"areaName"]=[ZYYCustomTool checkNullWithNSString:[NSString getCity]];//地区id（这个可以不传）
    NSString * url=[NSString stringWithFormat:@"%@/sysArea/getAreaIdByAreaName.json",ftpPath];


    NSLog(@"地区参数%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",requestDic.mj_JSONString);
        //将得到的areaid 保存下来
        if ([requestDic[@"status"] integerValue]==1) {
            NSString *cityId = [NSString stringWithFormat:@"%@",requestDic[@"data"]];
            if ([NSString checkForNull:cityId]) { // 如果没有此id,存北京的id
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults setObject:@"110100" forKey:@"areaID"];
            }else{
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults setObject:[NSString stringWithFormat:@"%@",requestDic[@"data"]] forKey:@"areaID"];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD showErrorWithStatus:@"地区获取失败"];
        NSLog(@"首页地区获取失败::%@",errorInfo);
    }];



}
-(void)loadData
{

    [self loadADData];
    [self loadVHeadData];
    [self loadHotData];

    [self refreshData];

}
-(void)loadMessageCount//未读消息数量统计
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];
    NSString * url=[NSString stringWithFormat:@"%@/sysMsg/auth/getSysMsgCount.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog(@"消息%@",requestDic);
        NSLog(@"msg%@",msg);
        if ([requestDic[@"status"] integerValue]==1) {
            _messageLab.text=[NSString stringWithFormat:@"%@",requestDic[@"data"]];//字典里边,data就是消息数量
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)loadADData//轮播图数据
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];

    dic[@"categoryId"]=@"0";//分类id(0:首页，1国内，2国外，3附近)
    NSString * url=[NSString stringWithFormat:@"%@/SysAdController/getSlideShow.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];

        NSLog_JSON(@"轮播图OK:%@",requestDic);
        _adsModel=[[VLXHomeAdsModel alloc] initWithDictionary:requestDic error:nil];
        if (_adsModel.status.integerValue==1) {
            NSMutableArray *imageUrlArr=[NSMutableArray array];
            for (VLXHomeAdsDataModel *dataModel in _adsModel.data) {
                NSLog(@"dataModel:%@~~%@",dataModel.adtitle,dataModel.adpostion);
                [imageUrlArr addObject:[ZYYCustomTool checkNullWithNSString:dataModel.adpicture]];
                [_AD_TitleArray addObject:[ZYYCustomTool checkNullWithNSString:dataModel.adtitle]];
            }
            NSLog(@"%ld",_AD_TitleArray.count);
            _adScrollView.imageURLStringsGroup=imageUrlArr;
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }

    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];



}
-(void)loadVHeadData//V头条数据
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
//    dic[@"areaId"]=@"0";//地区id（这个可以不传）
    NSString * url=[NSString stringWithFormat:@"%@/ProVHeadController/getVHeads.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
//        NSLog(@"%@",requestDic.mj_JSONString);
        [SVProgressHUD dismiss];
        _vHeadModel=[[VLXVHeadModel alloc] initWithDictionary:requestDic error:nil];
        
  
        if (_vHeadModel.status.integerValue==1) {
            [self.tableView reloadData];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)loadHotData//获取热门目的地
{

    //测试不同的账号登录之后的用户id是否有变化↓↓
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSLog(@"正式的用户id::%@",tihuanStr);
    //测试不同的账号登录之后用户的id是否有变化↑↑

    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    //    dic[@"areaId"]=@"0";//地区id（这个可以不传）
    NSString * url=[NSString stringWithFormat:@"%@/ProHotAreaController/getHotArea.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
//        NSLog_JSON(@"热门目的地OK:%@",requestDic);
        _hotModel=[[VLXHomeHotModel alloc] initWithDictionary:requestDic error:nil];
        if (_hotModel.status.integerValue==1) {
            [self.tableView reloadData];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)loadRecommandData:(int )type//获取热门推荐 当季游玩数据
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前所在页，每页展示9个数据
    dic[@"typenum"]=[NSString stringWithFormat:@"%ld",_recommandType];//2热门推荐 1当季游玩
    NSString * url=[NSString stringWithFormat:@"%@/ProRecommendController/getProRecommend.json",ftpPath];
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSLog(@"当季游玩参数:%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog_JSON(@"当季游玩数据:%@",requestDic);
        _recommandModel=[[VLXHomeRecommandModel alloc] initWithDictionary:requestDic error:nil];
        if (_recommandModel.status.integerValue == 1) {

            
            if (type == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:_recommandModel.data];
            if(self.dataArr.count==0)
            {
                if(!_nodateView)
                {
                    _nodateView=[[TitleButtonNoDataView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_tableView.frame))];
                    _nodateView.delegate=self;
                    _nodateView.titleText=@"暂无数据";
                    [self.tableView addSubview:_nodateView];
                    _nodateView.noDataButtonIsHidden=NO;
                }
                [self.tableView reloadData];//新增
            }
            else
            {
                if(_nodateView)
                {
                    [_nodateView removeFromSuperview];
                    _nodateView=nil;
                    _tableView.tableFooterView=nil;
                }

                [self.tableView reloadData];
            }
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else {
            
            [SVProgressHUD showErrorWithStatus:msg];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];

            [self.tableView reloadData];
            
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
//
#pragma mark--刷新
-(void)refreshData
{
    self.currentPage=1;

    [self loadRecommandData:1];
}
#pragma mark--加载
-(void)reloadMoreData
{
    self.currentPage++;
    [self loadRecommandData:2];
}


#pragma mark
#pragma mark---视图
-(void)createNav
{
    CGFloat leftHeight=14;
    //左边
    UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, leftHeight)];
    _cityLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, leftHeight)];

    _cityLab.font=[UIFont systemFontOfSize:14];
    _cityLab.textAlignment=NSTextAlignmentCenter;
    [leftView addSubview:_cityLab];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cityLab.frame)+3, (leftHeight-4)/2, 7, 4)];
    [imageView setImage:[UIImage imageNamed:@"pull-down"]];
    [leftView addSubview:imageView];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftView];
    //添加手势
    leftView.userInteractionEnabled=YES;
    UITapGestureRecognizer *leftTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftNavItemClicked:)];
    [leftView addGestureRecognizer:leftTap];
    //中间
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 7, ScaleWidth(240), 44-7*2)];
    titleView.layer.cornerRadius=4;
    titleView.layer.masksToBounds=YES;
    titleView.layer.borderColor=orange_color.CGColor;
    titleView.layer.borderWidth=1;
    self.navigationItem.titleView=titleView;
    UIImageView *search=[[UIImageView alloc] initWithFrame:CGRectMake(ScaleWidth(56.5), (30-17)/2, 17, 17)];
    [search setImage:[UIImage imageNamed:@"search"]];
    [titleView addSubview:search];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(search.frame)+5, 0, CGRectGetWidth(titleView.frame)-ScaleWidth(56.5)*2, 30)];
    titleLab.text=@"请输入关键词查询";
    titleLab.textColor=[UIColor hexStringToColor:@"#999999"];
    titleLab.font=[UIFont systemFontOfSize:14];
    titleLab.textAlignment=NSTextAlignmentLeft;
    [titleView addSubview:titleLab];
    //
    titleView.userInteractionEnabled=YES;
    UITapGestureRecognizer *centerTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerNavItemClicked:)];
    [titleView addGestureRecognizer:centerTap];
    //右边
    CGFloat imageWidth=22;
    UIImageView *rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    [rightImageView setImage:[UIImage imageNamed:@"message-no"]];
    _messageLab=[[UILabel alloc] initWithFrame:CGRectMake(imageWidth-7, -7, 14, 14)];
    _messageLab.backgroundColor=[UIColor whiteColor];
//    _messageLab.text=@"99";
    _messageLab.textColor=orange_color;
    _messageLab.font=[UIFont boldSystemFontOfSize:10];
    [rightImageView addSubview:_messageLab];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightImageView];
    //添加手势
    rightImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *rightTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightNavItemClicked:)];
    [rightImageView addGestureRecognizer:rightTap];
}
-(void)createUI
{
    [self createNav];
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kSafeAreaBottomHeight-44) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    

    [self.view addSubview:_tableView];
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSLog(@"手机系统版本:%@",phoneVersion);

    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXHomeHeaderCell" bundle:nil] forCellReuseIdentifier:@"VLXHomeHeaderCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXHomeHotCell" bundle:nil] forCellReuseIdentifier:@"VLXHomeHotCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXHomeRecommandCell" bundle:nil] forCellReuseIdentifier:@"VLXHomeRecommandCellID"];
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];

    
    //广告轮播图
    _adScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, ScaleHeight(178)) delegate:self placeholderImage:ADNoDataImage];
    _adScrollView.currentPageDotColor=[UIColor hexStringToColor:@"#06f400"];
    _adScrollView.pageControlAliment=SDCycleScrollViewPageContolAlimentRight;
    _tableView.tableHeaderView=_adScrollView;
    //
    [self createSelectHeaderView];
    //置顶按钮
    UIButton *topBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    float iphoneX_height;
    iphoneX_height=0;
    if (self.view.frame.size.height>667) {//如果屏幕高度大于667,就是苹果X
        iphoneX_height=25;
    }
    
    topBtn.frame=CGRectMake(K_SCREEN_WIDTH-6-40, K_SCREEN_HEIGHT - kSafeAreaBottomHeight -45-64-49-iphoneX_height , 40, 40);//
//    NSLog(@"置顶1:%@",NSStringFromCGRect(self.view.frame));
//    NSLog(@"置顶2:%f",self.view.frame.size.height);
    [topBtn setImage:[UIImage imageNamed:@"fanhuidingbu"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(btnClickedToTop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBtn];
}
-(void)createSelectHeaderView//当季游玩 热门推荐
{
    __block VLXHomeController *blockSelf=self;
    _selectHeaderView=[[VLXHomeSelectHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //回调刷新数据
    _selectHeaderView.headerBlock=^(NSInteger index)
    {
        blockSelf.currentPage=1;
        blockSelf.recommandType=index+1;
        [blockSelf refreshData];
    };
    
}
#pragma mark
#pragma mark---事件
-(void)btnClickedToTop:(UIButton *)sender
{

    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
//点击导航条左边item弹出选择地区的方法
-(void)leftNavItemClicked:(id)sender
{

    NSLog(@"leftNavItemClicked");
    __block VLXHomeController *blockSelf=self;
    VLXCityChooseVC * city=[[VLXCityChooseVC alloc]init];
    [self.navigationController pushViewController:city animated:YES];


}
#pragma mark 跳转推送消息列表
-(void)rightNavItemClicked:(id)sender
{
//    NSLog(@"rightNavItemClicked");
    if (![NSString getDefaultToken]) {
        [ZYYCustomTool userToLoginWithVC:self];//跳转登录
        return;
    }
    VLXMessageCenterVC * message=[[VLXMessageCenterVC alloc]init];
    [self.navigationController pushViewController:message animated:YES];
}
-(void)centerNavItemClicked:(id)sender
{
    NSLog(@"centerNavItemClicked");
    VLXSearchVC *searchVC=[[VLXSearchVC alloc] init];
    searchVC.cellType=1;
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark
#pragma mark---广告轮播图 delegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"广告轮播图A :%ld",index);
    NSMutableArray *imageUrlArr=[NSMutableArray array];
    NSMutableArray *typeArr    =[NSMutableArray array];//判断类型,跳转url 或者 类

    for (VLXHomeAdsDataModel *dataModel in _adsModel.data) {
        [imageUrlArr addObject:[ZYYCustomTool checkNullWithNSString:dataModel.adcontents]];
        [typeArr addObject:[ZYYCustomTool checkNullWithNSString:[NSString stringWithFormat:@"%@",dataModel.adtype]]];//adtype为nsnumber类型
        NSLog(@"dataModel.title:%@",dataModel.adtitle);
    }
    NSString *urlStr = imageUrlArr[index];
    NSString * typeString = typeArr[index];
    NSString * ad_titleString = _AD_TitleArray[index];
    if ([typeString isEqualToString:@"0"]) {
//        NSLog(@"type值为0,是一个url");

//        if ([ad_titleString containsString:@"诚招"]){//V旅行诚招全国各地省市服务商
            VLX_webView_Vc*webView = [[VLX_webView_Vc alloc]init];
            webView.urlStr = urlStr;
            webView.type = 4;
            webView.adTitle= ad_titleString;
            [self.navigationController pushViewController:webView animated:YES];
////        }
//        else{
//            VLXWebViewVC *webView = [[VLXWebViewVC alloc]init];
//            webView.urlStr = urlStr;
//            webView.type = 4;
//            webView.adTitle= ad_titleString;
//            [self.navigationController pushViewController:webView animated:YES];

//        }
    }
    else{
//        NSLog(@"type值为1,是一个类");
        UINavigationController *nav = self.cyl_tabBarController.selectedViewController;
        NSString * classNamestr = urlStr;
                id myObj = [[NSClassFromString(classNamestr) alloc] init];//找到类名,然后跳转
                [nav pushViewController:myObj animated:YES];
    }

}
#pragma mark
#pragma mark---no data delegate
-(void)titleButtonNoDataView:(TitleButtonNoDataView *)view didClickButton:(UIButton *)button
{
    NSLog(@"titleButtonNoDataView");
    [self refreshData];
}
#pragma mark
#pragma mark---tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else if (section==1)
    {
        return _dataArr.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block VLXHomeController *blockSelf=self;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            VLXHomeHeaderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXHomeHeaderCellID" forIndexPath:indexPath];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (_vHeadModel.data&&_vHeadModel.data.count>0) {
                [cell createUIWithData:_vHeadModel];
            }
            cell.topBlock=^(NSInteger index)
            {
                if (index==0) {//附近categoryId=3
                    VLXHomeNearByVC *nearVC=[[VLXHomeNearByVC alloc] init];
                    [blockSelf.navigationController pushViewController:nearVC animated:YES];
                }else if (index==1)//国内categoryId=1
                {
                    VLXDomesticVC *domesticVC=[[VLXDomesticVC alloc] init];
                    [blockSelf.navigationController pushViewController:domesticVC animated:YES];
                }else if (index==2)//境外categoryId=2
                {
                    VLXOutSideVC *outsideVC=[[VLXOutSideVC alloc] init];
                    [blockSelf.navigationController pushViewController:outsideVC animated:YES];
                }else if (index==3)//发现景点
                {
                    VLXFindPalaceVC * findVC=[[VLXFindPalaceVC alloc]init];
                    [self.navigationController pushViewController:findVC animated:YES];
                }else if (index==4)//更多
                {
                    [SVProgressHUD showInfoWithStatus:@"暂未开放，请您期待"];
                }
            };
            cell.centerBlock=^()//v头条
            {
                VLXTopNewsVC *newsVC=[[VLXTopNewsVC alloc] init];
                newsVC.vModel=_vHeadModel;
                [blockSelf.navigationController pushViewController:newsVC animated:YES];
            };
            cell.bottomBlock=^(NSInteger index)
            {
                if (index==0) {//火车票

                    VLXWebViewVC *webVC=[[VLXWebViewVC alloc] init];
                    webVC.urlStr = @"http://touch.train.qunar.com/?bd_source=vlvxing";
                    webVC.type=1;
                    [blockSelf.navigationController pushViewController:webVC animated:YES];
                }else if (index==1)//机票
                {

//                    VLXWebViewVC *webVC=[[VLXWebViewVC alloc] init];
//                    webVC.urlStr=@"http://url.cn/49r5tyf";
////                    webVC.urlStr = @"http://touch.train.qunar.com/?bd_source=vlvxing";
//                    webVC.type=2;
//                    [blockSelf.navigationController pushViewController:webVC animated:YES];
                    
                    VLX_TicketViewController * TicketVc = [[VLX_TicketViewController alloc]init];
                    TicketVc.locaString = _cityLab.text;
                    [blockSelf.navigationController pushViewController:TicketVc animated:YES];
                    
                }else if (index==2)//定制票
                {
                    if (![NSString getDefaultToken]) {
                        [ZYYCustomTool userToLoginWithVC:self];
                        return;
                    }
                    UIStoryboard *customSB=[UIStoryboard storyboardWithName:@"CustomSB" bundle:nil];
                    VLXCustomTripTableViewVC *tripVC=[customSB instantiateViewControllerWithIdentifier:@"VLXCustomTripTableViewVCID"];
                    [blockSelf.navigationController pushViewController:tripVC animated:YES];
                }else if (index==3)//用车
                {
                    if (![NSString getDefaultToken]) {
                        [ZYYCustomTool userToLoginWithVC:self];
                        return;
                    }
                    VLXUserCarVC *useCarVC=[[VLXUserCarVC alloc] init];
                    useCarVC.type=1;
                    [blockSelf.navigationController pushViewController:useCarVC animated:YES];
                }
            };
            return cell;
        }
        else if (indexPath.row==1)
        {
            VLXHomeHotCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXHomeHotCellID" forIndexPath:indexPath];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (_hotModel.data&&_hotModel.data.count>=indexPath.row) {
                [cell createUIWithModel:_hotModel];
            }
            cell.homeHotBlock=^(NSInteger index)
            {
                VLXHomeHotDataModel *dataModel=blockSelf.hotModel.data[index];
                VLXHotDestinationVC *destinationVC=[[VLXHotDestinationVC alloc] init];
                //
                destinationVC.areaID=[NSString stringWithFormat:@"%@",dataModel.areaid];//
                destinationVC.isForeign=[NSString stringWithFormat:@"%@",dataModel.isforeign];//1国内，2国外,3东南亚,,,
                //
                [blockSelf.navigationController pushViewController:destinationVC animated:YES];
            };
            return cell;
        }
    }
    else if (indexPath.section==1)
    {
        VLXHomeRecommandCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXHomeRecommandCellID" forIndexPath:indexPath];
        cell.isHasMargin=NO;
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
            [cell createUIWithModel:dataModel];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 262;
        }else if (indexPath.row==1)
        {
            return 152;
        }
    }
    else if (indexPath.section==1)
    {
        return 137+35;
    }
    return 0.0001;
    
}
//头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return _selectHeaderView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 48.5;
    }
    return 0.0001;
}
//脚部视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section:%ld,row:%ld",indexPath.section,indexPath.row);
    if (indexPath.section==1) {
        VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
        VLXRouteDetailVC *detailVC=[[VLXRouteDetailVC alloc] init];
        detailVC.detailModel = dataModel;
        detailVC.travelproductID=[NSString stringWithFormat:@"%@",dataModel.travelproductid];
        NSLog(@"👌:%@",detailVC.travelproductID);
        NSLog(@"图片吗👌:%@",dataModel.advertisebigpic);
        detailVC.adpic = dataModel.advertisebigpic;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
//
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//http://app.mtvlx.cn/lvyous_upload/common/2018-03-13/CM1520903400257.png//广告启动图


@end
