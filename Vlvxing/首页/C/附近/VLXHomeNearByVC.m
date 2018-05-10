//
//  VLXHomeNearByVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXHomeNearByVC.h"
#import "VLXNearByHeaderCell.h"
#import "VLXHomeRecommandCell.h"
#import "VLXNearByHeaderView.h"
#import "VLXPersonDriveVC.h"
#import "VLXFarmCourtryVC.h"
#import "VLXUserCarVC.h"
#import "VLXWeekendTripVC.h"
#import "VLXSearchVC.h"
//数据
#import "VLXHomeAdsModel.h"

#import "VLXHomeRecommandModel.h"
//
#import "VLXRouteDetailVC.h"
#import "VLXCityChooseVC.h"
#import "VLXWebViewVC.h"
@interface VLXHomeNearByVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TitleButtonNoDataViewDelegate>
{
    BOOL _isSepcial,_isOrder,_isSelf,_isTheme;//特价 排序 自助 主题
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)SDCycleScrollView *adScrollView;//广告轮播图
@property (nonatomic,strong)VLXNearByHeaderView *selectHeaderView;
@property  (nonatomic,strong)UILabel *cityLab;
//
@property (nonatomic,strong)VLXHomeAdsModel *adsModel;
@property (nonatomic,strong)VLXHomeRecommandModel *recommandModel;
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; // 存放当季游玩 热门推荐数据
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
//
@end

@implementation VLXHomeNearByVC
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
    //添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyToChangeCity:) name:@"changeCity" object:nil];
}
-(void)notifyToChangeCity:(NSNotification *)notify
{
    _cityLab.text=[NSString getCity];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化
    _currentPage=1;
    _dataArr=[NSMutableArray array];
    //
    [self createUI];
    [self loadData];
}
#pragma mark---数据
-(void)loadData
{
//    _adScrollView.localizationImageNamesGroup=@[@"guanggao",@"qicheguanggao",@"qicheguanggao"];
    [self loadADData];
    [self refreshData];
    
}
-(void)loadADData//轮播图数据
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"categoryId"]=@"3";//分类id(0:首页，1国内，2国外，3附近)
    NSString * url=[NSString stringWithFormat:@"%@/SysAdController/getSlideShow.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        
        _adsModel=[[VLXHomeAdsModel alloc] initWithDictionary:requestDic error:nil];
        if (_adsModel.status.integerValue==1) {
            NSMutableArray *imageUrlArr=[NSMutableArray array];
            for (VLXHomeAdsDataModel *dataModel in _adsModel.data) {
                [imageUrlArr addObject:[ZYYCustomTool checkNullWithNSString:dataModel.adpicture]];
            }
            _adScrollView.imageURLStringsGroup=imageUrlArr;
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)getAreaIDWithCity:(NSString *)city//根据地区获取areaid
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"areaName"]=[ZYYCustomTool checkNullWithNSString:[NSString getCity]];//地区id（这个可以不传）
    NSString * url=[NSString stringWithFormat:@"%@/sysArea/getAreaIdByAreaName.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        //        NSLog(@"%@",requestDic.mj_JSONString);
        //将得到的areaid 保存下来
        if ([requestDic[@"status"] integerValue]==1) {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%@",requestDic[@"data"]] forKey:@"areaID"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
        
    } failure:^(NSString *errorInfo) {
        //        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"地区获取失败"];
        
    }];
}

#pragma mark--刷新
-(void)refreshData
{
    self.currentPage=1;
    [self getNearProductData:1];
}
#pragma mark--加载
-(void)reloadMoreData
{
    self.currentPage++;
    [self getNearProductData:2];
}


#pragma mark
-(void)getNearProductData:(int)type//点击附近时获取商品列表  或者   附近中的自驾游和周末游
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
//    dic[@"areaId"]=@"110100";//地区id
    dic[@"areaId"]=[NSString getAreaID];//地区id
    dic[@"isSpecialPrice"]=[NSString stringWithFormat:@"%d",_isSepcial];//0不是特价，1是
    dic[@"isOrder"]=[NSString stringWithFormat:@"%d",_isOrder];//0不排序，1排序
    dic[@"isSelf"]=[NSString stringWithFormat:@"%d",_isSelf];//0不自助，1自助
    dic[@"isTheme"]=[NSString stringWithFormat:@"%d",_isTheme];//0不主题，1主题

    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前页
    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据

    NSString * url=[NSString stringWithFormat:@"%@/ProNearController/nearProductList.html",ftpPath];
    NSLog(@"附近参数-------:%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
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
                    _nodateView=[[TitleButtonNoDataView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kScreenHeight-64-ScaleHeight(178)-109-CGRectGetHeight(_selectHeaderView.frame))];
                    _nodateView.backgroundColor=[UIColor whiteColor];
                    _nodateView.delegate=self;
                    _nodateView.titleText=@"暂无数据";
//                    [self.tableView addSubview:_nodateView];
                    _tableView.tableFooterView=_nodateView;
                    _nodateView.noDataButtonIsHidden=NO;
                    //                    _nodateView.nobtnTitle=@"立即设置";
                }
                [self.tableView reloadData];
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
#pragma mark
#pragma mark---视图
-(void)createUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNav];
    [self createSelectHeaderView];
    //
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXNearByHeaderCell" bundle:nil] forCellReuseIdentifier:@"VLXNearByHeaderCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXHomeRecommandCell" bundle:nil] forCellReuseIdentifier:@"VLXHomeRecommandCellID"];
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    //广告轮播图
    _adScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, ScaleHeight(178)) delegate:self placeholderImage:[UIImage imageNamed:@"guanggao"]];
    _adScrollView.currentPageDotColor=[UIColor hexStringToColor:@"#06f400"];
    _adScrollView.pageControlAliment=SDCycleScrollViewPageContolAlimentRight;
    _tableView.tableHeaderView=_adScrollView;
    //
    
}
-(void)createSelectHeaderView
{
    __block VLXHomeNearByVC *blockSelf=self;
    _selectHeaderView=[[VLXNearByHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andTitleArray:@[@"全部",@"自助",@"特价",@"主题",@"排序"]];
    _selectHeaderView.nearBlock=^(NSInteger index)
    {
        //重置
        _isSepcial=NO;
        _isOrder=NO;
        _isSelf=NO;
        _isTheme=NO;
        if (index==0) {//
            
        }else if (index==1)//
        {
            _isSelf=YES;
        }else if (index==2)//
        {
            _isSepcial=YES;
        }else if (index==3)//
        {
            _isTheme=YES;
        }else if (index==4)//
        {
            _isOrder=YES;
        }
        [blockSelf refreshData];
    };
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
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton:)];
    //中间
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 7, kScreenWidth-80, 30)];
    titleView.layer.cornerRadius=4;
    titleView.layer.masksToBounds=YES;
    titleView.layer.borderColor=orange_color.CGColor;
    titleView.layer.borderWidth=1;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:titleView];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(11, (30-17)/2, 17, 17)];
    [imageView setImage:[UIImage imageNamed:@"search"]];
    [titleView addSubview:imageView];
    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, 0, 120, 30)];
    titleLab.text=@"请输入关键词搜索";
    titleLab.textColor=[UIColor hexStringToColor:@"#999999"];
    titleLab.font=[UIFont systemFontOfSize:14];
    titleLab.textAlignment=NSTextAlignmentLeft;
    [titleView addSubview:titleLab];
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(titleView.frame)-70, 3, 0.5, 30-3*2)];
    line.backgroundColor=orange_color;
    [titleView addSubview:line];
    //
    CGFloat cityHeight=14;
    CGFloat margin=(CGRectGetWidth(titleView.frame)-CGRectGetMaxX(line.frame)-55)/2;
    UIView *cityView=[[UIView alloc] initWithFrame:CGRectMake(margin+CGRectGetMaxX(line.frame), (30-cityHeight)/2, 55, cityHeight)];

    _cityLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, cityHeight)];
    _cityLab.text=[NSString getCity];
    _cityLab.font=[UIFont systemFontOfSize:14];
    _cityLab.textAlignment=NSTextAlignmentCenter;
    [cityView addSubview:_cityLab];
    UIImageView *imageView1=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cityLab.frame)+3, (cityHeight-4)/2, 7, 4)];
    [imageView1 setImage:[UIImage imageNamed:@"pull-down"]];
    [cityView addSubview:imageView1];
    [titleView addSubview:cityView];
    //添加手势
    //
    cityView.userInteractionEnabled=YES;
    UITapGestureRecognizer *cityTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToChooseCity:)];
    [cityView addGestureRecognizer:cityTap];
    //
    titleView.userInteractionEnabled=YES;
    UITapGestureRecognizer *centerTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerNavItemClicked:)];
    [titleView addGestureRecognizer:centerTap];
}
#pragma mark
#pragma mark---事件
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)centerNavItemClicked:(id)sender
{
    NSLog(@"centerNavItemClicked");
    VLXSearchVC *searchVC=[[VLXSearchVC alloc] init];
    searchVC.cellType=2;
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)tapToChooseCity:(UITapGestureRecognizer *)tap
{
    NSLog(@"tapToChooseCity");
    __block VLXHomeNearByVC *blockSelf=self;
    VLXCityChooseVC * city=[[VLXCityChooseVC alloc]init];
    [self.navigationController pushViewController:city animated:YES];

}
#pragma mark
#pragma mark---广告轮播图 delegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSMutableArray *imageUrlArr=[NSMutableArray array];
    NSMutableArray * titleAryy = [NSMutableArray array];
    for (VLXHomeAdsDataModel *dataModel in _adsModel.data) {
        [imageUrlArr addObject:[ZYYCustomTool checkNullWithNSString:dataModel.adcontents]];
        [titleAryy addObject:[ZYYCustomTool checkNullWithNSString:dataModel.adtitle]];
    }
    
    NSLog(@"广告轮播图:%ld",index);
    NSString *urlStr =imageUrlArr[index];
    NSString * titlee = titleAryy[index];
    VLXWebViewVC *webView = [[VLXWebViewVC alloc]init];
    webView.urlStr = urlStr;
    webView.type = 4;
    webView.title = titlee;
    [self.navigationController pushViewController:webView animated:YES];
}
#pragma mark
#pragma mark---no data delegate
-(void)titleButtonNoDataView:(TitleButtonNoDataView *)view didClickButton:(UIButton *)button
{
    NSLog(@"titleButtonNoDataView");
    [self refreshData];
}
#pragma mark
#pragma mark---delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block VLXHomeNearByVC *blockSelf=self;
    if (indexPath.section==0) {
        VLXNearByHeaderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXNearByHeaderCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.headBlock=^(NSInteger index)
        {
            if (index==0) {//自驾游
                VLXPersonDriveVC *driveVC=[[VLXPersonDriveVC alloc] init];
                [blockSelf.navigationController pushViewController:driveVC animated:YES];
            }else if (index==1)//周末游
            {
                VLXWeekendTripVC *tripVC=[[VLXWeekendTripVC alloc] init];
                [blockSelf.navigationController pushViewController:tripVC animated:YES];
            }else if (index==2)//农家院
            {
                VLXFarmCourtryVC *farmVC=[[VLXFarmCourtryVC alloc] init];
                [blockSelf.navigationController pushViewController:farmVC animated:YES];
            }else if (index==3)//景点用车
            {
                VLXUserCarVC *userVC=[[VLXUserCarVC alloc] init];
                userVC.type=0;
                [blockSelf.navigationController pushViewController:userVC animated:YES];
            }else if (index==4)//更多
            {
                [SVProgressHUD showInfoWithStatus:@"暂未开放，请您期待"];
            }
        };
        return cell;
    }else if (indexPath.section==1)
    {
        VLXHomeRecommandCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXHomeRecommandCellID" forIndexPath:indexPath];
        cell.isHasMargin=YES;
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
            [cell createUIWithModel:dataModel];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 101+8;
    }else if (indexPath.section==1)
    {
        return 137+44+8;
    }
    return 0.0001;
}
//头视图
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
        return 44+8;
    }
    return 0.0001;
}


//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
        VLXRouteDetailVC *detailVC=[[VLXRouteDetailVC alloc] init];
        detailVC.detailModel = dataModel;
        detailVC.travelproductID=[NSString stringWithFormat:@"%@",dataModel.travelproductid];
        [self.navigationController pushViewController:detailVC animated:YES];
    }

}
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
