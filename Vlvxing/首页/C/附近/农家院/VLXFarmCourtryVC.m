//
//  VLXFarmCourtryVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXFarmCourtryVC.h"
#import "VLXFarmCourtryCell.h"
#import "VLXFarmHeaderView.h"
#import "VLXFarmSelectView.h"
#import "VLXRouteDetailVC.h"
#import "VLXHomeRecommandModel.h"
#import "VLXSearchVC.h"
@interface VLXFarmCourtryVC ()<UITableViewDataSource,UITableViewDelegate,TitleButtonNoDataViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)VLXFarmHeaderView *farmHeaderView;
@property (nonatomic,strong)VLXFarmSelectView *leftSelectView;//选择排序
@property (nonatomic,strong)VLXFarmSelectView *rightSelectView;//位置选择
@property (nonatomic,assign)NSInteger chooseFlag;//
@property (nonatomic,assign)NSInteger distanceFlag;//
//
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; //
@property (nonatomic,strong)VLXHomeRecommandModel *recommandModel;
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
//
@end

@implementation VLXFarmCourtryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    _chooseFlag=1;//高价优先
    _distanceFlag=0;//距离不限
    //初始化
    _currentPage=1;
    _dataArr=[NSMutableArray array];
    //
    //
    [self createUI];
    [self loadData];
}
#pragma mark---数据
-(void)loadData
{
    [self refreshData];
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

    dic[@"areaId"]=[NSString getAreaID];//地区id
    dic[@"oderbyType"]=[NSString stringWithFormat:@"%ld",_chooseFlag];//0低价优先，1高价优先
    dic[@"location"]=[NSString stringWithFormat:@"%ld",_distanceFlag];//0:不限，1：500m 2：1km 3:3km 5:5km 10:10km
    dic[@"PathLng"]=[NSString getLongtitude];//地点经度
    dic[@"PathLat"]=[NSString getLatitude];//地点纬度
    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前页
    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
    
    
//    dic[@"areaId"]=@"110100";//地区id
//    dic[@"oderbyType"]=[NSString stringWithFormat:@"%ld",_chooseFlag];//0低价优先，1高价优先
//    dic[@"location"]=[NSString stringWithFormat:@"%ld",_distanceFlag];//0:不限，1：500m 2：1km 3:3km 5:5km 10:10km
//    dic[@"PathLng"]=@"116.482951";//地点经度
//    dic[@"PathLat"]=@"39.913365";//地点纬度
//    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前页
//    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
    NSString * url=[NSString stringWithFormat:@"%@/ProNearController/farmyardProductList.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
//        NSLog(@"%@",requestDic.mj_JSONString);
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
                    _nodateView=[[TitleButtonNoDataView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kScreenHeight-64-CGRectGetHeight(_farmHeaderView.frame))];
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
#pragma mark
#pragma mark---视图
-(void)createUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNav];
    [self createSelectHeaderView];

    //
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_farmHeaderView.frame), kScreenWidth, kScreenHeight-64-CGRectGetHeight(_farmHeaderView.frame)) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXFarmCourtryCell" bundle:nil] forCellReuseIdentifier:@"VLXFarmCourtryCellID"];
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    //筛选条件
    [self createLeftSelectView];
    [self createRightSelectView];
    //
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
    titleLab.text=@"搜索地区";
    titleLab.textColor=[UIColor hexStringToColor:@"#999999"];
    titleLab.font=[UIFont systemFontOfSize:14];
    titleLab.textAlignment=NSTextAlignmentLeft;
    [titleView addSubview:titleLab];
    //    //
    titleView.userInteractionEnabled=YES;
    UITapGestureRecognizer *centerTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerNavItemClicked:)];
    [titleView addGestureRecognizer:centerTap];
    
}
-(void)createSelectHeaderView
{
    __block VLXFarmCourtryVC *blockSelf=self;
    _farmHeaderView=[[VLXFarmHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _farmHeaderView.farmHeaderBlock=^(NSInteger index,BOOL isSelected)
    {
        if (index==1) {
            if (blockSelf.chooseFlag==0) {
                blockSelf.leftSelectView.currentIndex=1;//将当前序号传过去
            }else if (blockSelf.chooseFlag==1)
            {
                blockSelf.leftSelectView.currentIndex=0;//将当前序号传过去
            }
//            blockSelf.leftSelectView.currentIndex=blockSelf.chooseFlag;//将当前序号传过去
            blockSelf.leftSelectView.hidden=isSelected;
            blockSelf.rightSelectView.hidden=YES;
        }else if (index==2)
        {
            if (blockSelf.distanceFlag==0) {
                blockSelf.distanceFlag=0;
            }else if (blockSelf.distanceFlag==1)
            {
                blockSelf.distanceFlag=1;
            }else if (blockSelf.distanceFlag==2)
            {
                blockSelf.distanceFlag=2;
            }else if (blockSelf.distanceFlag==3)
            {
                blockSelf.distanceFlag=3;
            }else if (blockSelf.distanceFlag==5)
            {
                blockSelf.distanceFlag=4;
            }else if (blockSelf.distanceFlag==10)
            {
                blockSelf.distanceFlag=5;
            }
//            blockSelf.rightSelectView.currentIndex=blockSelf.distanceFlag;//将当前序号传过去
            blockSelf.rightSelectView.hidden=isSelected;
            blockSelf.leftSelectView.hidden=YES;
            
        }
    };
    [self.view addSubview:_farmHeaderView];
}
-(void)createLeftSelectView
{
    _leftSelectView=[[VLXFarmSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_farmHeaderView.frame), kScreenWidth, kScreenHeight-64-CGRectGetHeight(_farmHeaderView.frame)) andTitle:@[@"高价优先",@"低价优先"]];
    [self.view addSubview:_leftSelectView];
    _leftSelectView.hidden=YES;
    //回调
    __block VLXFarmCourtryVC *blockSelf=self;
    _leftSelectView.selectBlock=^(NSInteger index)
    {
//        blockSelf.chooseFlag=index;
        if (index==0) {
            blockSelf.chooseFlag=1;
        }else
        {
            blockSelf.chooseFlag=0;
        }
        [blockSelf.farmHeaderView leftChangeToNormal];
        [blockSelf refreshData];
    };
}
-(void)createRightSelectView
{
    _rightSelectView=[[VLXFarmSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_farmHeaderView.frame), kScreenWidth, kScreenHeight-64-CGRectGetHeight(_farmHeaderView.frame)) andTitle:@[@"不限",@"500m",@"1km",@"3km",@"5km",@"10km"]];
    [self.view addSubview:_rightSelectView];
    _rightSelectView.hidden=YES;
    //回调
    __block VLXFarmCourtryVC *blockSelf=self;
    _rightSelectView.selectBlock=^(NSInteger index)//0:不限，1：500m 2：1km 3:3km 5:5km 10:10km
    {
        
        if (index==0) {
            blockSelf.distanceFlag=index;
        }else if (index==1)
        {
            blockSelf.distanceFlag=index;
        }else if (index==2)
        {
            blockSelf.distanceFlag=index;
        }else if (index==3)
        {
            blockSelf.distanceFlag=index;
        }else if (index==4)
        {
            blockSelf.distanceFlag=5;
        }else if (index==5)
        {
            blockSelf.distanceFlag=10;
        }
        [blockSelf.farmHeaderView rightChangeToNormal];
        [blockSelf refreshData];
    };
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
    searchVC.cellType=4;
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark
#pragma mark---title no data delegate
-(void)titleButtonNoDataView:(TitleButtonNoDataView *)view didClickButton:(UIButton *)button
{
    NSLog(@"titleButtonNoDataView");
    [self refreshData];
}
#pragma mark
#pragma mark---delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXFarmCourtryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXFarmCourtryCellID" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (_dataArr&&_dataArr.count>indexPath.row) {
        VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
        [cell createUIWithModel:dataModel];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 191+55+17;//多一行字需要预留
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
    VLXRouteDetailVC *detailVC=[[VLXRouteDetailVC alloc] init];
    detailVC.detailModel = dataModel;
    detailVC.travelproductID=[NSString stringWithFormat:@"%@",dataModel.travelproductid];

    [self.navigationController pushViewController:detailVC animated:YES];

}
#pragma mark
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}


@end
