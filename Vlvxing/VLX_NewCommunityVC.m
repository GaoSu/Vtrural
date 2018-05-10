//
//  VLX_NewCommunityVC.m
//  Vlvxing
//
//  Created by grm on 2018/1/25.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_NewCommunityVC.h"


//相机相关
#import <AssetsLibrary/AssetsLibrary.h>//将拍摄好的照片写入系统相册中需要的类


#import "VLX_Community_DetailViewController.h"//详情页
#import "VLX_Search_CommunityViewController.h"//搜索
#import "VLX_message_CommViewController.h"//消息列表


#import "VLX_CommunityTBVW_Cell.h"
#import "VLX_newCommnuityModel.h"

#import "VLX_CommnuityTBVW_Cell_gz.h"
#import "VLX_newCommnuityModel_gz.h"

#import "VLX_CommnuityTBVW_Cell_fj.h"
#import "VLX_newCommnuityModel_fj.h"



//天气相关
#import "WSLocation.h"
#import "WeatherModel.h"

//#import "ZTHpinglunbianjiVC.h"//评论
#import "HMComposeViewController.h"//发帖(图文,或文字)
#import "ComposeVc_videos.h"//发视频的帖,或文字帖(3.22新)

#import "VLX_status.h"
#import "HMStatusFrame.h"


@interface VLX_NewCommunityVC ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIImagePickerControllerDelegate>{
    UIView * fabuView;//点击发布悬浮按钮之后弹出的view
    VLX_newCommnuityModel * model;
    VLX_newCommnuityModel_gz * model_gz;
    VLX_newCommnuityModel_fj * model_fj;



    UIView * bigimgVw2;
    NSUInteger ttt;

//    NSString * myselfUserId;//本人的id


}

@property(nonatomic,strong)CLLocationManager *locationmanager;//定位
@property  (nonatomic,copy)NSString * cityText;
@property (nonatomic,strong)WeatherModel *model;
@property (nonatomic,strong)UIImageView * weatherImgV;//天气
@property (nonatomic,strong)UILabel * weatherLb;

//@property (nonatomic,strong)UILabel * searchLb;//搜索框

@property (nonatomic,strong)UIImageView * messageImgV;//消息
@property (nonatomic,strong)UILabel * messageNoLb;//消息数量

@property (nonatomic,strong)UIButton * sele_topBt;//头部三个选择按钮
@property (nonatomic,strong)UIButton * sele_topBt2;//头部三个选择按钮
@property (nonatomic,strong)UIButton * sele_topBt3;//头部三个选择按钮

@property (nonatomic,strong)UITableView * tableVW1;
@property (nonatomic,strong)UITableView * tableVW2;
@property (nonatomic,strong)UITableView * tableVW3;

@property (nonatomic,strong)UIButton *bt2;

@property (nonatomic,strong)NSMutableArray * mainDynamicDataArray;//主列表帖子数据,
@property (nonatomic,strong)NSMutableArray * mainDynamicDataAray_2;//主列表帖子数据,用于传值,
@property (nonatomic,strong)NSMutableArray * mainUserDataArray;//主列表用户数据,
@property (nonatomic,copy)NSMutableArray * idArray;//专门存放动态的ID

//关注
@property (nonatomic,strong)NSMutableArray * mainDynamicDataArray_gz;//主列表帖子数据,
@property (nonatomic,strong)NSMutableArray * mainDynamicDataAray_2_gz;//主列表帖子数据,用于传值,
@property (nonatomic,strong)NSMutableArray * mainUserDataArray_gz;//主列表用户数据,
@property (nonatomic,copy)NSMutableArray * idArray_gz;//专门存放动态的ID

//附近
@property (nonatomic,strong)NSMutableArray * mainDynamicDataArray_fj;//主列表帖子数据,
@property (nonatomic,strong)NSMutableArray * mainDynamicDataAray_2_fj;//主列表帖子数据,用于传值,
@property (nonatomic,strong)NSMutableArray * mainUserDataArray_fj;//主列表用户数据,
@property (nonatomic,copy)NSMutableArray * idArray_fj;//专门存放动态的ID

//当前页
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageIndex_gz;
@property (nonatomic,assign) NSInteger pageIndex_fj;

@property (nonatomic,strong)VLX_status * vlx_status;
//@property (nonatomic, strong) NSMutableArray *heightArray;


@end

@implementation VLX_NewCommunityVC


- (NSMutableArray *)mainDynamicDataArray_gz//懒
{
    if (_mainDynamicDataArray_gz == nil) {
        _mainDynamicDataArray_gz = [NSMutableArray array];
    }
    return _mainDynamicDataArray_gz;
}

- (NSMutableArray *)mainDynamicDataArray_fj//懒
{
    if (_mainDynamicDataArray_fj == nil) {
        _mainDynamicDataArray_fj = [NSMutableArray array];
    }
    return _mainDynamicDataArray_fj;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;

//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
//    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
//    myselfUserId = tihuanStr;//正式的用户id,真实的用户id

    _mainDynamicDataArray = [NSMutableArray array];
    _mainDynamicDataAray_2 = [NSMutableArray array];
    _mainUserDataArray = [NSMutableArray array];
    _idArray = [NSMutableArray array];


    _mainDynamicDataAray_2_gz = [NSMutableArray array];
    _mainUserDataArray_gz = [NSMutableArray array]; //主列表用户数据,
    _idArray_gz = [NSMutableArray array];//专门存放动态的ID

    _mainDynamicDataAray_2_fj =[NSMutableArray array];
    _mainUserDataArray_fj = [NSMutableArray array]; //主列表用户数据,
    _idArray_fj = [NSMutableArray array];//专门存放动态的ID

    //读取沙盒中 保存的地区名字
//    NSString * localAreastr = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
//    NSLog(@"天气的地区:%@",localAreastr);

    NSString *areaName=[NSString getCity];
    NSLog(@"天气的地区:%@",areaName);

    //请求天气数据
    [self sendRequestToServer:areaName];

    [self makeNav];


    [self makeMineUI];
    // 集成刷新控件
    [self setupRefresh];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)makeNav//150  88
{


    //左边
    UIView *weatherView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    //天气&温度
    _weatherImgV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 2, 24, 24)];

    _weatherLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, 70, 13)];
    _weatherLb.textAlignment = NSTextAlignmentCenter;
    _weatherLb.font = [UIFont systemFontOfSize:13];
    [weatherView addSubview:_weatherImgV];
    [weatherView addSubview:_weatherLb];

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:weatherView];

    //中间
    UIView *searchView=[[UIView alloc] initWithFrame:CGRectMake(0, 7, ScaleWidth(240), 44-7*2)];
    searchView.layer.cornerRadius=15;
    searchView.layer.masksToBounds=YES;
    searchView.layer.borderColor=gray_color.CGColor;
    searchView.layer.borderWidth=1;
    self.navigationItem.titleView=searchView;
    //
    UILabel *searchTitleLab=[[UILabel alloc] initWithFrame:CGRectMake(40, 6, ScaleWidth(160), 18)];
    searchTitleLab.text=@"搜索关键词查询";
    searchTitleLab.textColor=[UIColor hexStringToColor:@"#999999"];
    searchTitleLab.font=[UIFont systemFontOfSize:14];
    searchTitleLab.textAlignment=NSTextAlignmentCenter;
    [searchView addSubview:searchTitleLab];
    searchView.userInteractionEnabled=YES;
    UITapGestureRecognizer *centerTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerNavItemClicked1)];
    [searchView addGestureRecognizer:centerTap];
    //    //右边
    //    CGFloat imageWidth=22;
    _messageImgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [_messageImgV setImage:[UIImage imageNamed:@"message-no"]];

    //消息数量
    _messageNoLb=[[UILabel alloc] initWithFrame:CGRectMake(22-7, -7,14 , 14)];
    _messageNoLb.backgroundColor=[UIColor redColor];
    _messageNoLb.text = @"13";
    _messageNoLb.textAlignment = NSTextAlignmentCenter;
    _messageNoLb.textColor=[UIColor whiteColor];
    _messageNoLb.font=[UIFont systemFontOfSize:10];
    _messageNoLb.clipsToBounds = YES;
    _messageNoLb.layer.cornerRadius = 7;
//    [_messageImgV addSubview:_messageNoLb];//暂时隐藏

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:_messageImgV];
    //    //添加手势
    _messageImgV.userInteractionEnabled=YES;
    UITapGestureRecognizer *rightTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightNavItemClicked1:)];
    [_messageImgV addGestureRecognizer:rightTap];





}
#pragma mark 点击搜索框跳转搜索界面
-(void)centerNavItemClicked1
{
    VLX_Search_CommunityViewController * vc = [[VLX_Search_CommunityViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 跳转消息列表
-(void)rightNavItemClicked1:(id)sender
{
    VLX_message_CommViewController * vc = [[VLX_message_CommViewController alloc]init];


    [self.navigationController pushViewController:vc animated:YES];

}
//三个列表
-(void)makeMineUI
{

    //有这一行,整个界面都有了
    self.automaticallyAdjustsScrollViewInsets = NO;

    _sele_topBt = [[UIButton alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth/3, 36)];
    [_sele_topBt setTitle:@"新鲜" forState:UIControlStateNormal];
    [_sele_topBt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _sele_topBt.selected = YES;
    [_sele_topBt addTarget:self action:@selector(buttonOfAction1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sele_topBt];

    //垃圾方法+ ScreenWidth/3 *i
    _sele_topBt2 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/3 , 0, ScreenWidth/3, 36)];
    [_sele_topBt2 setTitle:@"关注" forState:UIControlStateNormal];
    [_sele_topBt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sele_topBt2 addTarget:self action:@selector(buttonOfAction2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sele_topBt2];

    _sele_topBt3 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/3+ScreenWidth/3 , 0, ScreenWidth/3, 36)];
    [_sele_topBt3 setTitle:@"附近" forState:UIControlStateNormal];
    [_sele_topBt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sele_topBt3 addTarget:self action:@selector(buttonOfAction3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sele_topBt3];

////线
    UILabel * linelb = [[UILabel alloc]initWithFrame:CGRectMake(0, 36.5, ScreenWidth, 0.5)];
    linelb.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:linelb];


    //1
    self.tableVW1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 37, ScreenWidth, ScreenHeight-64-30-49) style:UITableViewStylePlain];
    self.tableVW1.delegate = self;
    self.tableVW1.dataSource = self;
    //去除多余分割线
    self.tableVW1.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];






//    //    //2
    _tableVW2 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth+5, 37, ScreenWidth, ScreenHeight-64-30-49) style:UITableViewStylePlain];
    _tableVW2.delegate = self;
    _tableVW2.dataSource = self;
    _tableVW2.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableVW2];

//    if (@available(iOS 11.0, *)) {//解决mj刷新在ios11上出现的frame乱跳问题
//        self.tableVW2.estimatedRowHeight = 0;
//        self.tableVW2.estimatedSectionFooterHeight = 0;
//        self.tableVW2.estimatedSectionHeaderHeight = 0;
//        self.tableVW2.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }

    //3
    _tableVW3 = [[UITableView alloc]initWithFrame:CGRectMake((ScreenWidth+5)*2, 37, ScreenWidth, ScreenHeight-64-30-49) style:UITableViewStylePlain];
    _tableVW3.delegate = self;
    _tableVW3.dataSource = self;
    _tableVW3.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

//    if (@available(iOS 11.0, *)) {//解决mj刷新在ios11上出现的frame乱跳问题
//        self.tableVW3.estimatedRowHeight = 0;
//        self.tableVW3.estimatedSectionFooterHeight = 0;
//        self.tableVW3.estimatedSectionHeaderHeight = 0;
//        self.tableVW3.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }

    [self.view addSubview:self.tableVW1];//一定要放在这个位置,不然,会被后加载的给遮盖住
    [self.view addSubview:_tableVW3];
    //延时加载window,注意我们需要在rootWindow创建完成之后再创建这个悬浮的按钮
    [self performSelector:@selector(creatSuspendBtn) withObject:nil afterDelay:0.2];

}
//三个按钮
#pragma mark top三个按钮
- (void)buttonOfAction1:(UIButton *)sender{
    sender = _sele_topBt;

    [_sele_topBt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sele_topBt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sele_topBt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    _tableVW1.frame = CGRectMake(0,  37, ScreenWidth, ScreenHeight-64-37-49);
    _tableVW2.frame = CGRectMake(ScreenWidth+5, 37, ScreenWidth, ScreenHeight-64-37-49);
    _tableVW3.frame = CGRectMake((ScreenWidth+5)*2, 37, ScreenWidth, ScreenHeight-64-37-49);

}

- (void)buttonOfAction2:(UIButton *)sender{



    sender = _sele_topBt2;

//    if (@available(iOS 11.0, *)) {//解决mj刷新在ios11上出现的frame乱跳问题
//        self.tableVW2.estimatedRowHeight = 0;
//        self.tableVW2.estimatedSectionFooterHeight = 0;
//        self.tableVW2.estimatedSectionHeaderHeight = 0;
//        self.tableVW2.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }



    [_sele_topBt  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sele_topBt2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sele_topBt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.tableVW1.hidden = YES;
//    _tableVW2.hidden =  NO;
//    _tableVW3.hidden = YES;
    if (_mainDynamicDataArray_gz.count==0) {
//        [self loadNewStatuses22];

        ////关注
        self.tableVW2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatuses22)];
        [self.tableVW2.mj_header beginRefreshing];
        self.tableVW2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatuses22)];
    }



    _tableVW2.frame = CGRectMake(0,  37, ScreenWidth, ScreenHeight-64-37-49);
    _tableVW1.frame = CGRectMake(ScreenWidth+5, 37, ScreenWidth, ScreenHeight-64-37-49);
    _tableVW3.frame = CGRectMake((ScreenWidth+5)*2, 37, ScreenWidth, ScreenHeight-64-37-49);



}

- (void)buttonOfAction3:(UIButton *)sender{

    sender = _sele_topBt3;

//    if (@available(iOS 11.0, *)) {//解决mj刷新在ios11上出现的frame乱跳问题
//        self.tableVW3.estimatedRowHeight = 0;
//        self.tableVW3.estimatedSectionFooterHeight = 0;
//        self.tableVW3.estimatedSectionHeaderHeight = 0;
//        self.tableVW3.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }

    if (_mainDynamicDataArray_fj.count==0) {

        ////关注
        self.tableVW3.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatuses33)];
        [self.tableVW3.mj_header beginRefreshing];
        self.tableVW3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatuses33)];
    }

    [_sele_topBt  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sele_topBt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sele_topBt3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    _tableVW3.frame = CGRectMake(0,  37, ScreenWidth, ScreenHeight-64-37-49);
    _tableVW2.frame = CGRectMake(ScreenWidth+5, 37, ScreenWidth, ScreenHeight-64-37-49);
    _tableVW1.frame = CGRectMake((ScreenWidth+5)*2, 37, ScreenWidth, ScreenHeight-64-37-49);
//    self.tableVW1.hidden = YES;
//    _tableVW2.hidden = YES;
//    _tableVW3.hidden = NO;

}



-(void)creatSuspendBtn{
    //悬浮按钮
    UIButton *topBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    float iphoneX_height;
    iphoneX_height=0;
    if (self.view.frame.size.height>667) {//如果屏幕高度大于667,就是苹果X
        iphoneX_height=25;
    }

    topBtn.frame=CGRectMake(K_SCREEN_WIDTH-6-40, K_SCREEN_HEIGHT - kSafeAreaBottomHeight -75-64-49-iphoneX_height , 40, 40);//

    [topBtn setImage:[UIImage imageNamed:@"加号2"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(suspendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBtn];

}
//按钮点击
-(void)suspendBtnClick{
    NSLog(@"点击悬浮按钮!");


    bigimgVw2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bigimgVw2.backgroundColor = rgba(100, 100, 100, 0.6);

    UITapGestureRecognizer* tapBigvw = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gunabiVw2)];

    [bigimgVw2 addGestureRecognizer:tapBigvw];

    //多一个像素
    fabuView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-282, ScreenWidth, 283)];
    fabuView.backgroundColor =[UIColor whiteColor];
    fabuView.layer.cornerRadius = 18;
    fabuView.layer.masksToBounds = YES;

    UIButton * xxbt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-45, 18, 25, 25)];
    [xxbt setImage:[UIImage imageNamed:@"筛选关闭（大）"] forState:UIControlStateNormal];
    [xxbt addTarget:self action:@selector(guanbiView) forControlEvents:UIControlEventTouchUpInside];


    UIButton * tuwenBt = [[UIButton alloc]initWithFrame:CGRectMake(95, 80, 60, 80)];
    [tuwenBt addTarget:self action:@selector(tuwen) forControlEvents:UIControlEventTouchUpInside];
    [tuwenBt setImage:[UIImage imageNamed:@"indent"] forState:UIControlStateNormal];
    [tuwenBt setTitle:@"图文" forState:UIControlStateNormal];
    [tuwenBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tuwenBt setFont:[UIFont systemFontOfSize:17]];

    //按钮图片文字上下:
    tuwenBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [tuwenBt setTitleEdgeInsets:UIEdgeInsetsMake(tuwenBt.imageView.frame.size.height+18 ,-tuwenBt.imageView.frame.size.width, 10.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [tuwenBt setImageEdgeInsets:UIEdgeInsetsMake(-10, 14, 18.0, -tuwenBt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边



    UIButton * shipinBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 95-40, 80, 60, 80)];

    [shipinBt addTarget:self action:@selector(shipin) forControlEvents:UIControlEventTouchUpInside];
    [shipinBt setImage:[UIImage imageNamed:@"information"] forState:UIControlStateNormal];
    [shipinBt setTitle:@"视频" forState:UIControlStateNormal];
    [shipinBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shipinBt setFont:[UIFont systemFontOfSize:17]];

    //按钮图片文字上下:
    shipinBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [shipinBt setTitleEdgeInsets:UIEdgeInsetsMake(shipinBt.imageView.frame.size.height+18 ,-shipinBt.imageView.frame.size.width, 10.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [shipinBt setImageEdgeInsets:UIEdgeInsetsMake(-10, 14, 18.0, -shipinBt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边




    [fabuView addSubview:xxbt];
    [fabuView addSubview:tuwenBt];
    [fabuView addSubview:shipinBt];

    [bigimgVw2 addSubview:fabuView];
    [self.navigationController.tabBarController.view addSubview:bigimgVw2];

//    [self.navigationController.tabBarController.view addSubview:fabuView];


}

-(void)gunabiVw2{

    [bigimgVw2 removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{


    [fabuView removeFromSuperview];
    [bigimgVw2 removeFromSuperview];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToChangeCity31:) name:@"changeCity" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [fabuView removeFromSuperview];
        [bigimgVw2 removeFromSuperview];
}
-(void)guanbiView//点击关闭按钮
{
    [fabuView removeFromSuperview];
        [bigimgVw2 removeFromSuperview];
}
#pragma mark 图文
-(void)tuwen{
    HMComposeViewController * vc = [[HMComposeViewController alloc]init];
    vc.tags = 0;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark 视频
-(void)shipin{

    ComposeVc_videos * vc =[[ComposeVc_videos alloc]init];
    
    [self.navigationController pushViewController:vc animated:NO];

}

#pragma delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.tableVW1 == tableView) {
        return self.mainDynamicDataArray.count;
    }
    else if (_tableVW2 == tableView) {
        return self.mainDynamicDataArray_gz.count;
    }
    else if (_tableVW3 == tableView) {
        return self.mainDynamicDataArray_fj.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableVW1 == tableView) {
//        NSLog(@"第1个列表高度%f",[self.mainDynamicDataArray[indexPath.row] CellHeight]);
        return [self.mainDynamicDataArray[indexPath.row] CellHeight];//自动计算高度
        
    }
    else if (_tableVW2 == tableView) {
        NSLog(@"第二个列表高度%f",[self.mainDynamicDataArray_gz[indexPath.row] CellHeight_gz]);
        return [self.mainDynamicDataArray_gz[indexPath.row] CellHeight_gz];
    }
    else if (_tableVW3 == tableView) {
        NSLog(@"第三个列表高度%f",[self.mainDynamicDataArray_fj[indexPath.row] CellHeight_fj]);
        return [self.mainDynamicDataArray_fj[indexPath.row] CellHeight_fj];
    }
    return 0;




}
#pragma mark - tableView代理方法
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [fabuView removeFromSuperview];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    if(self.tableVW1 == tableView)
    {
        static NSString *ID = @"cell1";
//        VLX_CommunityTBVW_Cell * cell = [self.tableVW1 dequeueReusableCellWithIdentifier:ID];
        VLX_CommunityTBVW_Cell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!cell){
            cell = [[VLX_CommunityTBVW_Cell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_mainDynamicDataArray.count > 0) {
            [cell FillWithModel:_mainDynamicDataArray[indexPath.row]];
            [cell.dianzanBt addTarget:self action:@selector(dianzanBt1:) forControlEvents:UIControlEventTouchUpInside];
            cell.dianzanBt.tag = indexPath.row;
        }
        return cell;
    }
    else if(_tableVW2 == tableView){
        static NSString *ID = @"cell2";

        VLX_CommnuityTBVW_Cell_gz *cell =[tableView cellForRowAtIndexPath:indexPath];// [self.tableVW2 dequeueReusableCellWithIdentifier:ID];//
        if (!cell) {
            cell = [[VLX_CommnuityTBVW_Cell_gz alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_mainDynamicDataArray_gz.count>0) {
            [cell FillWithModel:_mainDynamicDataArray_gz[indexPath.row]];
            [cell.dianzanBt addTarget:self action:@selector(dianzanBt2:) forControlEvents:UIControlEventTouchUpInside];
            cell.dianzanBt.tag = indexPath.row;
        }

        return cell;
    }
    else if(_tableVW3 == tableView){
        static NSString *ID = @"cell3";

        VLX_CommnuityTBVW_Cell_fj *cell = [tableView cellForRowAtIndexPath:indexPath]; //[self.tableVW3 dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[VLX_CommnuityTBVW_Cell_fj alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_mainDynamicDataArray_fj.count>0) {
            [cell FillWithModel:_mainDynamicDataArray_fj[indexPath.row]];
            [cell.dianzanBt addTarget:self action:@selector(dianzanBt3:) forControlEvents:UIControlEventTouchUpInside];
            cell.dianzanBt.tag = indexPath.row;
        }

        return cell;

    }


    return nil;

}
#pragma mark 点赞
-(void)dianzanBt1:(UIButton *)sender{
    VLX_CommunityTBVW_Cell *cell = [[VLX_CommunityTBVW_Cell alloc]init];

    UIButton * btn = [[UIButton alloc]init];
    btn = cell.dianzanBt;
     ttt = sender.tag;
     VLX_newCommnuityModel * model3 = _mainDynamicDataArray[ttt];//找到对应的行号
    if([model3.isFavor isEqual:@0]){//未点赞
        [btn setImage:[UIImage imageNamed:@"like_highlighted"] forState:UIControlStateNormal];
        model3.isFavor = @1;
        [MBProgressHUD showSuccess:@"点赞成功"];
//        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ttt inSection:0];
        [self.tableVW1 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if([model3.isFavor isEqual:@1]){//已近点赞
        [btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        model3.isFavor = @0;

        [MBProgressHUD showSuccess:@"取消点赞"];

        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ttt inSection:0];
        [self.tableVW1 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    NSString * url3 = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/favor.json"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

    dic[@"userid"] = myselfUserId;//本人的用户id,不是帖子发布者的id
    dic[@"weiboId"] = model3.dynamicId;//帖子id
    [HMHttpTool get:url3 params:dic success:^(id responseObj) {
        NSLog(@"点赞OK:::%@",responseObj);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
-(void)dianzanBt2:(UIButton *)sender{
    VLX_CommnuityTBVW_Cell_gz *cell = [[VLX_CommnuityTBVW_Cell_gz alloc]init];

    UIButton * btn = [[UIButton alloc]init];
    btn = cell.dianzanBt;
    ttt = sender.tag;
    VLX_newCommnuityModel_gz * model3 = _mainDynamicDataArray_gz[ttt];//找到对应的行号
    if([model3.isFavor isEqual:@0]){//未点赞
        [btn setImage:[UIImage imageNamed:@"like_highlighted"] forState:UIControlStateNormal];
        model3.isFavor = @1;
        [MBProgressHUD showSuccess:@"点赞成功"];
        //        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ttt inSection:0];
        [self.tableVW2 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if([model3.isFavor isEqual:@1]){//已近点赞
        [btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        model3.isFavor = @0;

        [MBProgressHUD showSuccess:@"取消点赞"];

        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ttt inSection:0];
        [self.tableVW2 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    NSString * url3 = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/favor.json"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

    dic[@"userid"] = myselfUserId;//本人的用户id,不是帖子发布者的id
    dic[@"weiboId"] = model3.dynamicId;//帖子id
    [HMHttpTool get:url3 params:dic success:^(id responseObj) {
        NSLog(@"点赞OK:::%@",responseObj);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
-(void)dianzanBt3:(UIButton *)sender{
    VLX_CommnuityTBVW_Cell_fj *cell = [[VLX_CommnuityTBVW_Cell_fj alloc]init];

    UIButton * btn = [[UIButton alloc]init];
    btn = cell.dianzanBt;
    ttt = sender.tag;
    VLX_newCommnuityModel_fj * model3 = _mainDynamicDataArray_fj[ttt];//找到对应的行号
    if([model3.isFavor isEqual:@0]){//未点赞
        [btn setImage:[UIImage imageNamed:@"like_highlighted"] forState:UIControlStateNormal];
        model3.isFavor = @1;
        [MBProgressHUD showSuccess:@"点赞成功"];
        //        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ttt inSection:0];
        [self.tableVW3 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if([model3.isFavor isEqual:@1]){//已近点赞
        [btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        model3.isFavor = @0;

        [MBProgressHUD showSuccess:@"取消点赞"];

        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:ttt inSection:0];
        [self.tableVW3 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    NSString * url3 = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/favor.json"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

    dic[@"userid"] = myselfUserId;//本人的用户id,不是帖子发布者的id
    dic[@"weiboId"] = model3.dynamicId;//帖子id
    [HMHttpTool get:url3 params:dic success:^(id responseObj) {
        NSLog(@"点赞OK:::%@",responseObj);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableVW1 == tableView) {
        VLX_Community_DetailViewController * vc = [[VLX_Community_DetailViewController alloc]init];
        [self.tableVW1 deselectRowAtIndexPath:indexPath animated:NO];
        vc.detailDic = self.mainDynamicDataAray_2[indexPath.row];
        vc.userDic   = self.mainUserDataArray[indexPath.row];
        vc.dynamic_id = self.idArray[indexPath.row];//帖子id

        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
        NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
        NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

        vc.myselfUserId = myselfUserId;
        [self.navigationController pushViewController:vc animated:YES];


    }
    else if (self.tableVW2 == tableView) {
        VLX_Community_DetailViewController * vc = [[VLX_Community_DetailViewController alloc]init];
        [self.tableVW2 deselectRowAtIndexPath:indexPath animated:NO];
        vc.detailDic = self.mainDynamicDataAray_2_gz[indexPath.row];
        vc.userDic   = self.mainUserDataArray_gz[indexPath.row];
        vc.dynamic_id = self.idArray_gz[indexPath.row];//帖子id

        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
        NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
        NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

        vc.myselfUserId = myselfUserId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (self.tableVW3 == tableView) {
        VLX_Community_DetailViewController * vc = [[VLX_Community_DetailViewController alloc]init];
        [self.tableVW3 deselectRowAtIndexPath:indexPath animated:NO];
        vc.detailDic = self.mainDynamicDataAray_2_fj[indexPath.row];
        vc.userDic   = self.mainUserDataArray_fj[indexPath.row];
        vc.dynamic_id = self.idArray_fj[indexPath.row];//帖子id

        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
        NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
        NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

        vc.myselfUserId = myselfUserId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//打开相册
-(void)openImageFile
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

//打开相机
- (void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;//如果没有打开权限,,,

    UIImagePickerController *ipc1 = [[UIImagePickerController alloc] init];
    ipc1.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray *availableMedia1 = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    NSLog(@"相机?:%@",availableMedia1);
    ipc1.mediaTypes = [NSArray arrayWithObject:availableMedia1[0]];//打开相机
    //    ipc1.mediaTypes = [NSArray arrayWithObject:availableMedia1[1]];//打开视频
    ipc1.delegate = self;
    [self presentViewController:ipc1 animated:YES completion:nil];


}

//加载数据
- (void)setupRefresh
{
/////新鲜
    self.tableVW1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatuses11)];
    [self.tableVW1.mj_header beginRefreshing];
    self.tableVW1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatuses11)];

////关注
//    self.tableVW2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatuses22)];
//    [self.tableVW2.mj_header beginRefreshing];
//    self.tableVW2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatuses22)];

////附近
//    self.tableVW3.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatuses33)];
//    [self.tableVW3.mj_header beginRefreshing];
//    self.tableVW3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatuses33)];

}

//加载最新的动态数据
- (void)loadNewStatuses11
{

    [SVProgressHUD showWithStatus:@"正在加载"];

    self.pageIndex = 1;//1381;

    [self.mainUserDataArray removeAllObjects];
    [self.mainDynamicDataAray_2 removeAllObjects];
    [self.mainDynamicDataArray removeAllObjects];
    [self.idArray removeAllObjects];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取经纬度 经度longtitude, 纬度latitude
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSString * weidu = [NSString stringWithFormat:@"%f",[userDefaultes floatForKey:@"latitude"]];
//    NSLog(@"纬度:%@",weidu);
//    NSString * jingdu = [NSString stringWithFormat:@"%f",[userDefaultes floatForKey:@"longtitude"]];
//    NSLog(@"经du:%@",jingdu);

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id


    params[@"currentPage"] = @(self.pageIndex);//
    params[@"loginUserid"] = myselfUserId;
    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];
//    NSString * url = [NSString stringWithFormat:@"%@%@",@"http://192.168.1.113:9000/lvxing",@"/weibo/list.json"];

    NSLog(@"列表参数::::%@",params);
    [HMHttpTool get:url params:params success:^(id responseObj) {
        [SVProgressHUD dismiss];

        NSLog_JSON(@"返回👌::::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {

            for (NSDictionary * dic in responseObj[@"data"]) {
                model = [VLX_newCommnuityModel infoListWithDict:dic];
                [self.mainUserDataArray addObject:model.member];
                [self.mainDynamicDataAray_2 addObject:dic];//向下传值用
                [self.mainDynamicDataArray addObject:model];
                [self.idArray addObject: model.dynamicId];
            }

            //请求成功后，一定要刷新界面

            [self.tableVW1 reloadData];
            // 让刷新控件停止刷新
            [self.tableVW1.mj_footer endRefreshing];
            [self.tableVW1.mj_header endRefreshing];

        }
    } failure:^(NSError *error) {
        [self.tableVW1.mj_footer endRefreshing];
        [self.tableVW1.mj_header endRefreshing];
        NSLog_JSON(@"返回失败::::::%@",error);
        [SVProgressHUD dismiss];

    }];



    /*
//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    //JSON文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Untitled_crashReason.json" ofType:nil];
    //加载JSON文件
    NSData *data = [NSData dataWithContentsOfFile:path];
    //将JSON数据转为NSArray或NSDictionary
//    NSArray *dictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog_JSON(@"1111%@",responseDic);
    for (NSDictionary * dic in responseDic[@"data"]) {
         model = [VLX_newCommnuityModel infoListWithDict:dic];
         [self.mainUserDataArray addObject:model.member];
         [self.mainDynamicDataArray addObject:model];
    }
    //请求成功后，一定要刷新界面
    [self.tableVW1 reloadData];
    //// 让刷新控件停止刷新
    [self.tableVW1.mj_footer endRefreshing];
    [self.tableVW1.mj_header endRefreshing];
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
     */


}
- (void)loadMoreStatuses11//加载更多
{

//    [self.tableVW1.mj_footer resetNoMoreData];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = @(++self.pageIndex);
    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];


    [HMHttpTool get:url params:params success:^(id responseObj) {
//        NSLog_JSON(@"返回👌::::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {

            for (NSDictionary * dic in responseObj[@"data"]) {
                model = [VLX_newCommnuityModel infoListWithDict:dic];
                [self.mainUserDataArray addObject:model.member];
                [self.mainDynamicDataAray_2 addObject:dic];//向下传值用
                [self.mainDynamicDataArray addObject:model];
                [self.idArray addObject: model.dynamicId];
            }

            //请求成功后，一定要刷新界面
            [self.tableVW1 reloadData];
            // 让刷新控件停止刷新

//            [self.tableVW1.mj_footer resetNoMoreData];

            [self.tableVW1.mj_footer endRefreshing];
            [self.tableVW1.mj_header endRefreshing];
//            self.tableVW1.mj_footer.state = MJRefreshStateNoMoreData;


        }
    } failure:^(NSError *error) {
        [self.tableVW1.mj_footer endRefreshing];
        [self.tableVW1.mj_header endRefreshing];
    }];



}

-(void)loadNewStatuses22{
    [SVProgressHUD showWithStatus:@"正在加载"];



    self.pageIndex_gz = 1;
    [self.mainUserDataArray_gz removeAllObjects];
    [self.mainDynamicDataAray_2_gz removeAllObjects];
    [self.mainDynamicDataArray_gz removeAllObjects];
    [self.idArray_gz removeAllObjects];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = @(self.pageIndex_gz);

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id

    params[@"loginUserid"] = myselfUserId;
    params[@"type"]=@2;
    NSLog(@"关注参数:::::%@",params);

    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];

    [HMHttpTool get:url params:params success:^(id responseObj) {
        [SVProgressHUD dismiss];

        NSLog_JSON(@"关注数据_返回👌::::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {

            for (NSDictionary * dic in responseObj[@"data"]) {
                model_gz = [VLX_newCommnuityModel_gz infoListWithDict:dic];
                [self.mainDynamicDataAray_2_gz addObject:dic];//向下传值用
                [self.mainUserDataArray_gz addObject:model_gz.member];
                [self.mainDynamicDataArray_gz addObject:model_gz];
                [self.idArray_gz addObject: model_gz.dynamicId];
//                NSLog(@"第二个列表数组::%ld",_mainDynamicDataArray_gz.count);
            }
            //请求成功后，一定要刷新界面
            [self.tableVW2 reloadData];
//            // 让刷新控件停止刷新
            [self.tableVW2.mj_footer endRefreshing];
            [self.tableVW2.mj_header endRefreshing];

        }
    } failure:^(NSError *error) {
        [self.tableVW2.mj_footer endRefreshing];
        [self.tableVW2.mj_header endRefreshing];
        NSLog_JSON(@"返回失败::::::%@",error);
        [SVProgressHUD dismiss];

    }];

}

- (void)loadMoreStatuses22//加载更多
{

    //消除尾部"没有更多数据"的状态
    [self.tableVW2.mj_footer resetNoMoreData];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"currentPage"] = @(++self.pageIndex_gz);

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id
    params[@"loginUserid"] = myselfUserId;
    params[@"type"]=@2;
    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];

    [HMHttpTool get:url params:params success:^(id responseObj) {

        //        NSLog_JSON(@"返回👌::::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {

            for (NSDictionary * dic in responseObj[@"data"]) {
                model_gz = [VLX_newCommnuityModel_gz infoListWithDict:dic];
                [self.mainUserDataArray_gz addObject:model_gz.member];
                [self.mainDynamicDataAray_2_gz addObject:dic];//向下传值用
                [self.mainDynamicDataArray_gz addObject:model_gz];
                [self.idArray_gz addObject: model_gz.dynamicId];
            }

            //请求成功后，一定要刷新界面
            [self.tableVW2 reloadData];
            // 让刷新控件停止刷新
            [self.tableVW2.mj_footer endRefreshing];
            [self.tableVW2.mj_header endRefreshing];
            self.tableVW2.mj_footer.state = MJRefreshStateNoMoreData;//没有数据显示已经加载完成


        }
    } failure:^(NSError *error) {
        [self.tableVW2.mj_footer endRefreshing];
        [self.tableVW2.mj_header endRefreshing];


    }];



}

- (void)loadNewStatuses33
{
    

    [SVProgressHUD showWithStatus:@"正在加载"];

    self.pageIndex_fj = 1;//1381;

    [self.mainUserDataArray_fj removeAllObjects];
    [self.mainDynamicDataAray_2_fj removeAllObjects];
    [self.mainDynamicDataArray_fj removeAllObjects];
    [self.idArray_fj removeAllObjects];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];


    params[@"currentPage"] = @(self.pageIndex_fj);

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id
    params[@"loginUserid"] = myselfUserId;
    params[@"type"]=@3;
    params[@"AreaId"]= [NSString getAreaID];
    NSLog(@"附近_参数%@",params);
    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];


    [HMHttpTool get:url params:params success:^(id responseObj) {
        [SVProgressHUD dismiss];

        NSLog_JSON(@"附近 返回数据👌::::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {

            for (NSDictionary * dic in responseObj[@"data"]) {
                model_fj = [VLX_newCommnuityModel_fj infoListWithDict:dic];
                [self.mainUserDataArray_fj addObject:model_fj.member];
                [self.mainDynamicDataAray_2_fj addObject:dic];//向下传值用
                [self.mainDynamicDataArray_fj addObject:model_fj];
                [self.idArray_fj addObject: model_fj.dynamicId];
            }
            [self.tableVW3 reloadData];
            [self.tableVW3.mj_footer endRefreshing];
            [self.tableVW3.mj_header endRefreshing];

        }
    } failure:^(NSError *error) {
        [self.tableVW3.mj_footer endRefreshing];
        [self.tableVW3.mj_header endRefreshing];
        NSLog_JSON(@"返回失败::::::%@",error);
        [SVProgressHUD dismiss];

    }];
}

- (void)loadMoreStatuses33{//加载更多

    //消除尾部"没有更多数据"的状态
    [self.tableVW3.mj_footer resetNoMoreData];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"currentPage"] = @(++self.pageIndex_fj);

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *tihuanStr = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    NSString * myselfUserId = tihuanStr;//正式的用户id,真实的用户id
    params[@"loginUserid"] = myselfUserId;
    params[@"type"]=@3;
    NSString * url = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];

    [HMHttpTool get:url params:params success:^(id responseObj) {
        //        NSLog_JSON(@"返回👌::::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                model_fj = [VLX_newCommnuityModel_fj infoListWithDict:dic];
                [self.mainUserDataArray_fj addObject:model_fj.member];
                [self.mainDynamicDataAray_2_fj addObject:dic];//向下传值用
                [self.mainDynamicDataArray_fj addObject:model_fj];
                [self.idArray_fj addObject: model_fj.dynamicId];
            }
            [self.tableVW3 reloadData];
            [self.tableVW3.mj_footer endRefreshing];
            [self.tableVW3.mj_header endRefreshing];
            self.tableVW3.mj_footer.state = MJRefreshStateNoMoreData;

        }
    } failure:^(NSError *error) {
        [self.tableVW3.mj_footer endRefreshing];
        [self.tableVW3.mj_header endRefreshing];
    }];
}





//请求天气数据
-(void)sendRequestToServer:(NSString *)cityName
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.thinkpage.cn/v3/weather/daily.json?key=osoydf7ademn8ybv&location=%@&language=zh-Hans&start=0&days=3",cityName];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//    NSLog(@"天气:%@",url);
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog_JSON(@"天气信息:%@",responseObject);

        NSArray *resultArray = responseObject[@"results"];
        for (NSDictionary *dic in resultArray) {

            WeatherModel *model = [[WeatherModel alloc]init];
            model.cityName = dic[@"location"][@"name"];
            model.todayDic = (NSDictionary *)[dic[@"daily"] objectAtIndex:0];//今天


            NSString * str1 =[NSString stringWithFormat:@"%@~%@°C",[model.todayDic objectForKey:@"high"],[model.todayDic objectForKey:@"low"]];
            _weatherLb.text = str1;

//            NSLog(@"图片:%@",[model.todayDic objectForKey:@"text_day"]);//只要将返回的数据的天气名字与图片名字对应上就可以
            _weatherImgV.image = [UIImage imageNamed:[model.todayDic objectForKey:@"text_day"]];

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];

}





@end
