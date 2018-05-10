//
//  VLXUserCarVC.m
//  Vlvxing
///Users/wojiuyou/Desktop/Vlvxing/Vlvxing.xcodeproj
//  Created by 王静雨 on 2017/5/22.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXUserCarVC.h"
#import "VLXUserCarCell.h"
#import "VLXUserCarHeaderView.h"
#import "VLXFarmSelectView.h"
#import "VLXHomeRecommandModel.h"
#import "VLXRouteDetailVC.h"
@interface VLXUserCarVC ()<UITableViewDelegate,UITableViewDataSource,TitleButtonNoDataViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)VLXUserCarHeaderView *headerView;
@property (nonatomic,strong)VLXFarmSelectView *leftSelectView;
@property (nonatomic,strong)VLXFarmSelectView *rightSelectView;
@property (nonatomic,assign)NSInteger chooseFlag;//
@property (nonatomic,assign)NSInteger distanceFlag;//
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; //
@property (nonatomic,strong)VLXHomeRecommandModel *recommandModel;
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
@property (nonatomic,assign)NSInteger carType;//0:接送机，1景点用车
@end

@implementation VLXUserCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    _chooseFlag=0;//综合排序
    _distanceFlag=0;//不限时间
    _carType=0;
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
//    dic[@"areaId"]=@"110100";//地区id
    dic[@"areaId"]=[NSString getAreaID];//地区id
//    dic[@"carInfoType"]=@"1";//0:接送机，1景点用车
    if (_type==0) {
        dic[@"carInfoType"]=@"1";//0:接送机，1景点用车
    }else if (_type==1)
    {
        dic[@"carInfoType"]=[NSString stringWithFormat:@"%ld",_carType];//0:接送机，1景点用车
    }
    dic[@"carTimeType"]=[NSString stringWithFormat:@"%ld",_distanceFlag];//0不限时间，1可定今日，2可定明日
    dic[@"oderbyType"]=[NSString stringWithFormat:@"%ld",_chooseFlag];//0综合排序，1销量排序，2低价优先，3高价优先
    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前页
    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
    
    NSString * url=[NSString stringWithFormat:@"%@/ProNearController/getNearCarInfoList.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
//                NSLog(@"%@",requestDic.mj_JSONString);
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
                    _nodateView=[[TitleButtonNoDataView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kScreenHeight-64-CGRectGetHeight(_headerView.frame))];
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
    [self createNav];
    
    [self createHeaderView];
    //
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_headerView.frame), kScreenWidth, kScreenHeight-64-CGRectGetHeight(_headerView.frame)) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXUserCarCell" bundle:nil] forCellReuseIdentifier:@"VLXUserCarCellID"];
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


    //
    self.title=@"景点用车";
    if (_type==0) {
        
    }else if (_type==1)
    {
        //中间
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-70*2, 44)];
        self.navigationItem.titleView=titleView;
        NSArray *titleArray=@[@"接送机",@"景点用车"];
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
        _line=[[UIView alloc] initWithFrame:CGRectMake((width-35)/2, 44-2, 40, 2)];
        _line.backgroundColor=orange_color;
        [titleView addSubview:_line];
    }
    //
//    //中间
//    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-80*2, 44)];
//    self.navigationItem.titleView=titleView;
//    NSArray *titleArray=@[@"接送机",@"景点用车"];
//    CGFloat width=CGRectGetWidth(titleView.frame)/2;
//    for (int i=0; i<2; i++) {
//        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame=CGRectMake(width*i, 0, width, 44);
//        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
//        btn.titleLabel.font=[UIFont systemFontOfSize:19];
//        if (i==0) {
//            [btn setTitleColor:orange_color forState:UIControlStateNormal];
//        }
//        else
//        {
//            [btn setTitleColor:[UIColor hexStringToColor:@"#313131"] forState:UIControlStateNormal];
//        }
//        btn.tag=100+i;
//        [btn addTarget:self action:@selector(NavItemClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [titleView addSubview:btn];
//    }
//    _line=[[UIView alloc] initWithFrame:CGRectMake((width-40)/2, 44-2, 40, 2)];
//    _line.backgroundColor=orange_color;
//    [titleView addSubview:_line];

}
-(void)createHeaderView
{
    __block VLXUserCarVC *blockSelf=self;
    _headerView=[[VLXUserCarHeaderView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_headerView];
    //回调
    _headerView.carHeaderBlock=^(NSInteger index,BOOL isSelected)
    {
        if (index==1) {
            blockSelf.leftSelectView.currentIndex=blockSelf.chooseFlag;//将当前序号传过去
            blockSelf.leftSelectView.hidden=isSelected;
            blockSelf.rightSelectView.hidden=YES;
        }else if (index==2)
        {
            blockSelf.rightSelectView.currentIndex=blockSelf.distanceFlag;//将当前序号传过去
            blockSelf.rightSelectView.hidden=isSelected;
            blockSelf.leftSelectView.hidden=YES;
            
        }
    };
}
-(void)createLeftSelectView
{
    _leftSelectView=[[VLXFarmSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_headerView.frame), kScreenWidth, kScreenHeight-64-CGRectGetHeight(_headerView.frame)) andTitle:@[@"综合排序",@"销量优先",@"低价优先",@"高价优先"]];
    [self.view addSubview:_leftSelectView];
    _leftSelectView.hidden=YES;
    //回调
    __block VLXUserCarVC *blockSelf=self;
    _leftSelectView.selectBlock=^(NSInteger index)
    {
        blockSelf.chooseFlag=index;
        [blockSelf.headerView leftChangeToNormal];
        [blockSelf refreshData];
    };
}
-(void)createRightSelectView
{
    _rightSelectView=[[VLXFarmSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_headerView.frame), kScreenWidth, kScreenHeight-64-CGRectGetHeight(_headerView.frame)) andTitle:@[@"不限时间",@"可定今日",@"可定明日"]];
    [self.view addSubview:_rightSelectView];
    _rightSelectView.hidden=YES;
    //回调
    __block VLXUserCarVC *blockSelf=self;
    _rightSelectView.selectBlock=^(NSInteger index)
    {
        blockSelf.distanceFlag=index;
        [blockSelf.headerView rightChangeToNormal];
        [blockSelf refreshData];
    };
}
#pragma mark
#pragma mark---事件
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)NavItemClicked:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    _carType=sender.tag-100;
    CGFloat width=(kScreenWidth-70*2)/2;
    CGFloat margin=(width-35)/2;
    UIButton *leftBtn=[self.navigationItem.titleView viewWithTag:100];
    UIButton *rightBtn=[self.navigationItem.titleView viewWithTag:101];
    if (sender.tag-100==0) {
        [leftBtn setTitleColor:orange_color forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor hexStringToColor:@"#313131"] forState:UIControlStateNormal];
    }else if (sender.tag-100==1)
    {
        [leftBtn setTitleColor:[UIColor hexStringToColor:@"#313131"] forState:UIControlStateNormal];
        [rightBtn setTitleColor:orange_color forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.28 animations:^{
        _line.frame=CGRectMake((sender.tag-100)*width+margin, _line.frame.origin.y, _line.frame.size.width, _line.frame.size.height);
    } completion:^(BOOL finished) {
        [self loadData];
    }];
    
}
#pragma mark
#pragma mark---title No data delegate
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
    VLXUserCarCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXUserCarCellID" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (_dataArr&&_dataArr.count>indexPath.row) {
        VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
        [cell createUIWithModel:dataModel];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
    VLXRouteDetailVC *detailVC=[[VLXRouteDetailVC alloc] init];
    detailVC.travelproductID=[NSString stringWithFormat:@"%@",dataModel.travelproductid];
    detailVC.detailModel = dataModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
