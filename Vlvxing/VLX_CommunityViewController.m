//
//  VLX_CommunityViewController.m
//  Vlvxing
//
//  Created by grm on 2017/10/18.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_CommunityViewController.h"//社交(社区 交流)


//相机相关
#import <AssetsLibrary/AssetsLibrary.h>//将拍摄好的照片写入系统相册中需要的类


#import "VLX_Community_DetailViewController.h"//详情页
#import "VLX_Search_CommunityViewController.h"//搜索
#import "VLX_message_CommViewController.h"//消息列表


#import "VLX_CommunityTBVW_Cell.h"
#import "VLX_CommunityMdel.h"

//天气相关
#import "WSLocation.h"
#import "WeatherModel.h"

//mofang
#import "HMStatus.h"
#import "HMStatusFrame.h"
#import "HMStatusCell.h"
#import "HMStatusOriginalView.h"
#import "HMStatusDetailView.h"
#import "HMStatusToolbar.h"
#import "HMAccountTool.h"
#import "HMAccount.h"
#import "HMStatusOriginalFrame.h"

#import "HMDynamic.h"
//#import "ZTHCollection.h"//收藏
#import "ZTHLike.h"//赞,喜欢

#import "ZTHpinglunbianjiVC.h"//评论
#import "HMComposeViewController.h"//发图片或文字


#import "VLX_status.h"

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

@interface VLX_CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIImagePickerControllerDelegate,HMStatusOriginalViewDelegate,HMBaseToolbarDelegage>
{
    VLX_CommunityMdel * model0;

    UIView * fabuView;//点击发布悬浮按钮之后弹出的view
    UIView * bigimgVw2;//半透明背景
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



// window
//@property (nonatomic,strong)UIWindow *window;
//悬浮按钮
//@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UIButton *bt2;

@property (nonatomic,strong)NSMutableArray *statusFrames;//主列表数据,
@property (nonatomic,strong)NSMutableArray * mainDynamicDataArray;//主列表帖子数据,
@property (nonatomic,strong)NSMutableArray * mainUserDataArray;//主列表用户数据,
@property (nonatomic,copy)NSMutableArray * idArray;//专门存放动态的ID
//当前页
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) HMStatus *status;//模型
@property (nonatomic,assign)NSInteger num;//选择框

@property (nonatomic,strong)VLX_status * vlx_status;
//dynamicId
@property (nonatomic,copy) NSString *dynamic_id;




@end

@implementation VLX_CommunityViewController
- (NSMutableArray *)statusFrames//懒
{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    _mainDynamicDataArray = [NSMutableArray array];
    _mainUserDataArray = [NSMutableArray array];
    _idArray = [NSMutableArray array];

    //读取沙盒中 保存的地区名字
    NSString * localAreastr = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    //请求天气数据
    [self sendRequestToServer:localAreastr];
    
    [self makeNav];


    [self makeMineUI];
    // 集成刷新控件
    [self setupRefresh];


    //监听底部工具条上xx和点赞的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBottomContent:) name:@"changeBottomContent" object:nil];

}
//监听通知的方法
- (void)changeBottomContent:(NSNotification *)notification
{
    [self.tableVW1 reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- HMBaseToolbarDelegage 工具条点击代理方法
- (void)toolBar:(HMBaseToolbar *)toolBar didClickButtonType:(HMBaseToolbarType)buttonType button:(UIButton *)button dynamic:(HMDynamic *)dynamic
{
    switch (buttonType) {
            //地区;
        case HM_Area:
            [self loadAreaDataWithButton:button dynamic:dynamic];
            break;

            //收藏
        case HMBaseToolbarCollection:

            [self loadCollectionDataWithButton:button dynamic:dynamic];

            break;
            //浏览量;
        case HM_Liulanliang:
            [self loadLiulanliangDataWithButton:button dynamic:dynamic];
            break;

            //评论
        case HMBaseToolbarComment:

            [self loadCommentDataWithButton:button dynamic:dynamic];
            break;

            //赞
        case HMBaseToolbarLike:

            [self loadLikeDataWithButton:button dynamic:dynamic];

            break;

        default:
            break;
    }
}

#pragma mark - 点击工具条按钮发送的请求
//点击底部工具条调用对应的接口
//地区
-(void)loadAreaDataWithButton:(UIButton *)area dynamic:(HMDynamic *)dynamic{

}


//收藏
- (void)loadCollectionDataWithButton:(UIButton *)collectionButton dynamic:(HMDynamic *)dynamic
{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"dynamicId"] = dynamic.dynamicId;


//    [HMHttpTool get:dynamic_collectionURL params:params success:^(id responseObj) {
//
//        NSLog_JSON(@"收藏--%@",responseObj[@"data"]);
//        ZTHCollection *collection = [ZTHCollection mj_objectWithKeyValues:responseObj[@"data"]];
//
//        dynamic.collectionState = collection.collectionState;
//        dynamic.collectionCount = collection.collectionCount;
//
//        [self.tableView reloadData];
//
//    } failure:^(NSError *error) {
//
//    }];

}
//浏览量
-(void)loadLiulanliangDataWithButton:(UIButton *)liulanliangBt dynamic:(HMDynamic *)dynamic{

}
//评论
- (void)loadCommentDataWithButton:(UIButton *)commentButton dynamic:(HMDynamic *)dynamic
{
    //    HMFUNC;

    NSIndexPath *myIndex=[self.tableVW1 indexPathForCell:(HMStatusCell*)[[[commentButton superview] superview] superview]];
    NSLog(@"第几个%ld",(long)myIndex.row);
    NSDictionary * dic3 = _idArray[myIndex.row];
    NSLog(@"点击了评论按钮%@",dic3);//拿到该评论的动态ID

        VLX_Community_DetailViewController * vc = [[VLX_Community_DetailViewController alloc]init];
        [self.tableVW1 deselectRowAtIndexPath:myIndex animated:NO];
        vc.detailDic = self.mainDynamicDataArray[myIndex.row];
        vc.userDic  = self.mainUserDataArray[myIndex.row];
        vc.tagss=1;
        [self.navigationController pushViewController:vc animated:YES];



}

//赞
- (void)loadLikeDataWithButton:(UIButton *)likeButton dynamic:(HMDynamic *)dynamic
{

    [HMHttpTool get:dynamic_likeURL params:nil success:^(id responseObj) {

        NSLog(@"点赞--%@",responseObj[@"data"]);
        ZTHLike *like = [ZTHLike mj_objectWithKeyValues:responseObj[@"data"]];

        dynamic.likeState = like.likeState;
        dynamic.likeCount = like.likeCount;

        [self.tableVW1 reloadData];

    } failure:^(NSError *error) {

    }];
}


- (void)refresh:(BOOL)fromSelf
{
    if (self.tabBarItem.badgeValue) { // 有数字
        // 刷新数据
        [self.tableVW1.mj_header beginRefreshing];
    } else if (fromSelf) { // 没有数字
        // 让表格回到最顶部
        NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableVW1 scrollToRowAtIndexPath:firstRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

//请求天气数据
-(void)sendRequestToServer:(NSString *)cityName
{
  AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.thinkpage.cn/v3/weather/daily.json?key=osoydf7ademn8ybv&location=%@&language=zh-Hans&start=0&days=3",cityName];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"天气信息:%@",responseObject);
        
        NSArray *resultArray = responseObject[@"results"];
        for (NSDictionary *dic in resultArray) {
            
            WeatherModel *model = [[WeatherModel alloc]init];
            model.cityName = dic[@"location"][@"name"];
            model.todayDic = (NSDictionary *)[dic[@"daily"] objectAtIndex:0];//今天
            
            
             NSString * str1 =[NSString stringWithFormat:@"%@~%@°C",[model.todayDic objectForKey:@"high"],[model.todayDic objectForKey:@"low"]];
            NSLog(@"wendu%@",str1);
            _weatherLb.text = str1;
            

            NSLog(@"图片:%@",[model.todayDic objectForKey:@"text_day"]);
            _weatherImgV.image = [UIImage imageNamed:[model.todayDic objectForKey:@"text_day"]];

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

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
    
    _messageNoLb=[[UILabel alloc] initWithFrame:CGRectMake(22-7, -7,14 , 14)];
    _messageNoLb.backgroundColor=[UIColor redColor];
    _messageNoLb.text = @"13";
    _messageNoLb.textAlignment = NSTextAlignmentCenter;
    _messageNoLb.textColor=[UIColor whiteColor];
    _messageNoLb.font=[UIFont systemFontOfSize:10];
    _messageNoLb.clipsToBounds = YES;
    _messageNoLb.layer.cornerRadius = 7;
    [_messageImgV addSubview:_messageNoLb];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//三个列表
-(void)makeMineUI
{
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

    
    
    UILabel * linelb = [[UILabel alloc]initWithFrame:CGRectMake(0, 36.5, ScreenWidth, 0.5)];
    linelb.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:linelb];
    
    
    //1
    self.tableVW1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 37, ScreenWidth, ScreenHeight-64-37-49) style:UITableViewStylePlain];
//    self.tableVW1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableVW1.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableVW1.delegate = self;
    self.tableVW1.dataSource = self;
    //去除多余分割线
    self.tableVW1.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    NSLog(@"尺寸:%@", NSStringFromCGRect(self.tableVW1.tableHeaderView.frame));

    
//    //2
    _tableVW2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 37, ScreenWidth, ScreenHeight-64-37-49) style:UITableViewStylePlain];
    _tableVW2.delegate = self;
    _tableVW2.dataSource = self;
    //去除多余分割线
    _tableVW2.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableVW2];
    //3
    _tableVW3 = [[UITableView alloc]initWithFrame:CGRectMake(0, 37, ScreenWidth, ScreenHeight-64-37-49) style:UITableViewStylePlain];
    _tableVW3.delegate = self;
    _tableVW3.dataSource = self;
    //去除多余分割线
    _tableVW3.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableVW3];

    [self.view addSubview:self.tableVW1];//一定要放在这个位置,不然,会被后加载的给遮盖住
    
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
    
    self.tableVW1.hidden = NO;
    _tableVW2.hidden = YES;
    _tableVW3.hidden = YES;
    
}

- (void)buttonOfAction2:(UIButton *)sender{

    sender = _sele_topBt2;
    
    [_sele_topBt  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sele_topBt2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sele_topBt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.tableVW1.hidden = YES;
    _tableVW2.hidden =  NO;
    _tableVW3.hidden = YES;
    
}

- (void)buttonOfAction3:(UIButton *)sender{

    sender = _sele_topBt3;
    [_sele_topBt  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sele_topBt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sele_topBt3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.tableVW1.hidden = YES;
    _tableVW2.hidden = YES;
    _tableVW3.hidden = NO;
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

    [topBtn setImage:[UIImage imageNamed:@"（大）筛选—机场落地-点击"] forState:UIControlStateNormal];
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



    fabuView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-282, ScreenWidth, 283)];//多一个像素
    fabuView.backgroundColor =rgba(240, 240, 240, 1);//[ UIColor lightGrayColor];


    UIButton * xxbt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-30, 0, 30, 30)];
    [xxbt setImage:[UIImage imageNamed:@"筛选关闭（大）"] forState:UIControlStateNormal];
    [xxbt addTarget:self action:@selector(guanbiView) forControlEvents:UIControlEventTouchUpInside];


    UIButton * tuwenBt = [[UIButton alloc]initWithFrame:CGRectMake(95, 80, 60, 80)];
    [tuwenBt addTarget:self action:@selector(tuwen) forControlEvents:UIControlEventTouchUpInside];
    [tuwenBt setImage:[UIImage imageNamed:@"shishilukuang"] forState:UIControlStateNormal];
    [tuwenBt setTitle:@"图文TAG" forState:UIControlStateNormal];
    [tuwenBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tuwenBt setFont:[UIFont systemFontOfSize:20]];

    //按钮图片文字上下:
    tuwenBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [tuwenBt setTitleEdgeInsets:UIEdgeInsetsMake(tuwenBt.imageView.frame.size.height+18 ,-tuwenBt.imageView.frame.size.width, 10.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [tuwenBt setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0, 18.0, -tuwenBt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边



    UIButton * shipinBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 95-40, 80, 60, 80)];

    [shipinBt addTarget:self action:@selector(shipin) forControlEvents:UIControlEventTouchUpInside];
    [shipinBt setImage:[UIImage imageNamed:@"摄像机"] forState:UIControlStateNormal];
    [shipinBt setTitle:@"视频" forState:UIControlStateNormal];
    [shipinBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shipinBt setFont:[UIFont systemFontOfSize:20]];

    //按钮图片文字上下:
    shipinBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [shipinBt setTitleEdgeInsets:UIEdgeInsetsMake(shipinBt.imageView.frame.size.height+18 ,-shipinBt.imageView.frame.size.width, 10.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [shipinBt setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0, 18.0, -shipinBt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边




    [fabuView addSubview:xxbt];
    [fabuView addSubview:tuwenBt];
    [fabuView addSubview:shipinBt];


    [self.navigationController.tabBarController.view addSubview:bigimgVw2];
//    [self.navigationController.tabBarController.view addSubview:fabuView];


}

//关闭背景
-(void)gunabiVw2
{

}

-(void)viewWillAppear:(BOOL)animated
{
    [fabuView removeFromSuperview];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [fabuView removeFromSuperview];
}
-(void)guanbiView//点击关闭按钮
{
    [fabuView removeFromSuperview];
}
//图文
-(void)tuwen{
    HMComposeViewController * vc = [[HMComposeViewController alloc]init];
    vc.tags = 0;        
    [self.navigationController pushViewController:vc animated:YES];
}

//视频
-(void)shipin{
    HMComposeViewController * vc = [[HMComposeViewController alloc]init];
    vc.tags = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.tableVW1 == tableView) {
        self.tableVW1.mj_footer.hidden = (self.statusFrames.count == 0);
        return self.statusFrames.count;
    }
    else if (_tableVW2 == tableView) {
        return 2;
    }
    else if (_tableVW3 == tableView) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 225;
    if (self.tableVW1 == tableView) {
    HMStatusFrame *frame = self.statusFrames[indexPath.row];
    NSLog(@"行高,动态设定:%f",frame.cellHeight);
    return frame.cellHeight;
    }
    else if (_tableVW2 == tableView) {
        return 111;
    }
    else if (_tableVW3 == tableView) {
        return 111;
    }
    return 0;




}

#pragma mark - tableView代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [fabuView removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{}



-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(self.tableVW1 == tableView)
    {

        HMStatusCell *cell = [HMStatusCell cellWithTableView:self.tableVW1];
        cell.statusFrame = self.statusFrames[indexPath.row];
//        cell.detailView.originalView.userInteractionEnabled =YES;
        cell.detailView.originalView.delegate = self;
        cell.toolbar.delegate = self;
        return cell;

    }
    else if(_tableVW2 == tableView){
        static NSString *ID = @"cell2";
        
        VLX_CommunityTBVW_Cell *cell = [self.tableVW1 dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[VLX_CommunityTBVW_Cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if(_tableVW3 == tableView){
        static NSString *ID = @"cell3";
        
        VLX_CommunityTBVW_Cell *cell = [self.tableVW1 dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[VLX_CommunityTBVW_Cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }

    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableVW1 == tableView) {
        VLX_Community_DetailViewController * vc = [[VLX_Community_DetailViewController alloc]init];
        [self.tableVW1 deselectRowAtIndexPath:indexPath animated:NO];
        vc.detailDic = self.mainDynamicDataArray[indexPath.row];
        vc.userDic  = self.mainUserDataArray[indexPath.row];
        vc.dynamic_id = self.idArray[indexPath.row];
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


- (void)setupRefresh
{
    self.tableVW1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatuses1)];
    [self.tableVW1.mj_header beginRefreshing];

    self.tableVW1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatuses1)];

}
//加载最新的动态数据
- (void)loadNewStatuses1
{
    self.pageIndex = 1;//1381;


    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//
//    //获取经纬度1.31,反了
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSString * jingdu = [NSString stringWithFormat:@"%f",[userDefaultes floatForKey:@"latitude"]];
//    NSLog(@"jingdu:%@",jingdu);
//    NSString * weidu = [NSString stringWithFormat:@"%f",[userDefaultes floatForKey:@"longtitude"]];
//    NSLog(@"weidu:%@",weidu);
//
//
////    params[@"currentPage"] = @(self.pageIndex);
////    params[@"PathLat"]=jingdu;//经度
////    params[@"PathLng"]=weidu;//纬度
    params[@"page"] = @(self.pageIndex);
    params[@"size"] = @(5);
////////params[@"otherUserId"] = _OtherUserID;
//
//
    NSString * url = [NSString stringWithFormat:@"%@",@"http://192.168.1.113:9000/lvxing/weibo/list.json"];
    [HMHttpTool get:dynamic_listURL params:params success:^(id responseObj) {
//    [HMHttpTool get:url params:params success:^(id responseObj) {
        [self.statusFrames removeAllObjects];

        NSLog_JSON(@"加载新的动态数据返回的模型%@",responseObj);

//        if ([responseObj[@"status"]  isEqual: @1]  ) {
        if ([responseObj[@"errorNo"]  isEqual: @101000]  ) {
            NSArray *statusFrames1 = [self statusFramesWithStatuses:[HMStatus mj_objectArrayWithKeyValuesArray:responseObj[@"data"]]];

            // 添加到当前类别对应的用户数组中
            [self.statusFrames addObjectsFromArray:statusFrames1];

            //获取所有的id/////////////////////////////////////////////↓
            for (NSDictionary * dicc in responseObj[@"data"]) {
                NSLog(@"zizidian%@",dicc);
//                [self.mainDynamicDataArray addObject:dicc];
                [self.mainDynamicDataArray addObject:dicc[@"dynamic"]];
                [self.mainUserDataArray addObject:dicc[@"user"]];
                [_idArray  addObject:dicc[@"dynamic"][@"dynamicId"]];

            }
            NSLog(@"id是多少:%ld",_idArray.count);//走了
            //获取所有的id/////////////////////////////////////////////↑

            //请求成功后，一定要刷新界面
            [self.tableVW1 reloadData];

            // 让刷新控件停止刷新（恢复默认的状态）
            [self.tableVW1.mj_header endRefreshing];
        }

    } failure:^(NSError *error) {
        // 让刷新控件停止刷新（恢复默认的状态）

        [self.tableVW1.mj_header endRefreshing];

    }];


//    [HMHttpTool get:url params:params success:^(id responseObj) {
//        NSLog_JSON(@"tangyaong👌:%@",responseObj);
//        if ([responseObj[@"status"] isEqual:@1]) {
//            NSArray *statusFrames1 = [self statusFramesWithStatuses:[HMStatus mj_objectArrayWithKeyValuesArray:responseObj[@"data"]]];
//            // 添加到当前类别对应的用户数组中
//            [self.statusFrames addObjectsFromArray:statusFrames1];
//
//            for (NSDictionary * dic in responseObj[@"data"]) {
//                [self.mainDynamicDataArray addObject:dic];
//                [self.mainUserDataArray addObject:dic[@"member"]];
//                [_idArray  addObject:dic[@"memberId"]];
//            }
//
//        }
//
//    } failure:^(NSError *error) {
//        NSLog(@"失败:%@",error);
//    }];




}
- (void)loadMoreStatuses1//加载更多
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(++self.pageIndex);
    params[@"size"] = @(5);

    [HMHttpTool get:dynamic_listURL params:params success:^(id responseObj) {

        NSLog_JSON(@"加载更多:%@",responseObj);
        NSArray *statusFrames = [self statusFramesWithStatuses:[HMStatus mj_objectArrayWithKeyValuesArray:responseObj[@"data"]]];

        // 添加到当前类别对应的用户数组中
        [self.statusFrames addObjectsFromArray:statusFrames];


        //获取所有的id/////////////////////////////////////////////↓
        for (NSDictionary * dicc in responseObj[@"data"]) {
//            NSLog(@"zizidian%@",dicc[@"dynamic"][@"dynamicId"]);
            [self.mainDynamicDataArray addObject:dicc[@"dynamic"]];
            [self.mainUserDataArray addObject:dicc[@"user"]];
            [_idArray  addObject:dicc[@"dynamic"][@"dynamicId"]];
            NSLog(@"第二个id是多少%@",_idArray);//👌
        }
        //获取所有的id/////////////////////////////////////////////↑

        //请求成功后，一定要刷新界面
        [self.tableVW1 reloadData];

        // 让刷新控件停止刷新（恢复默认的状态）
        [self.tableVW1.mj_footer endRefreshing];

    } failure:^(NSError *error) {

        [self.tableVW1.mj_footer endRefreshing];

    }];
}

#pragma mark - 加载WB 数据


//   根据WB 模型数组 转成 WB frame模型数据
//@param statuses WB 模型数组
- (NSMutableArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (HMStatus *status in statuses) {

        HMStatusFrame *frame = [[HMStatusFrame alloc] init];
        // 传递WB 模型数据，计算所有子控件的frame
        frame.status = status;
        //最后一个模型会把原来的模型都覆盖掉
        _vlx_status = status;
        //存储到本地
        [HMAccountTool saveDynamic:self.status.dynamic];
//        [HMAccountTool saveVideo:self.status.dynamic.video];
        [HMAccountTool saveUser:self.status.user];

        [frames addObject:frame];
    }
    return frames;
}



@end
