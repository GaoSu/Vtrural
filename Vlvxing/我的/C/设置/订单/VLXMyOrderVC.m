//
//  VLXMyOrderVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMyOrderVC.h"
#import "VLXCustomNavTitleView.h"//自定义titleview
#import "VLXOrderHeaderView.h"//自定义的headerview
#import "VLXOrderCarTableViewCell.h"//cell
#import "VLXMyOrderModel.h"
#import "VLXMyOrderDetailVC.h"//详情
@interface VLXMyOrderVC ()<UITableViewDelegate,UITableViewDataSource,TitleButtonNoDataViewDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)VLXMyOrderModel *myOrderModel;
@property (nonatomic,assign)NSInteger orderType;//订单类别   1 出行订单 2 用车订单
@property (nonatomic,assign)NSInteger statutType;//1.全部  2待付款  3待评价
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; //数据源
@end

@implementation VLXMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    _orderType=1;
    _statutType=1;
    //
    _currentPage=1;
    _dataArr=[NSMutableArray array];
    //
    //
    [self createUI];
//    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark---数据
#pragma mark---数据
-(void)loadData
{
    [self refreshData];
}
#pragma mark--刷新
-(void)refreshData
{
    self.currentPage=1;
    [self getMyOrderData:1];
}
#pragma mark--加载
-(void)reloadMoreData
{
    self.currentPage++;
    [self getMyOrderData:2];
}


#pragma mark
-(void)getMyOrderData:(int)type//我的订单
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前所在页，每页展示9个数据
    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
    dic[@"token"]=[NSString getDefaultToken];
    dic[@"statutType"]=[NSString stringWithFormat:@"%ld",_statutType];//1.全部  2待付款  3待评价
    dic[@"orderType"]=[NSString stringWithFormat:@"%ld",_orderType];//1.出行订单  2用车订单
    NSString * url=[NSString stringWithFormat:@"%@/OrderInfoController/auth/getOrderList.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
//                NSLog(@"%@",requestDic.mj_JSONString);
        _myOrderModel=[[VLXMyOrderModel alloc] initWithDictionary:requestDic error:nil];
        if (_myOrderModel.status.integerValue == 1) {
            
            
            if (type == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:_myOrderModel.data];
            if(self.dataArr.count==0)
            {
                if(!_nodateView)
                {
                    _nodateView=[[TitleButtonNoDataView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kScreenHeight-64)];
                    _nodateView.backgroundColor=[UIColor whiteColor];
                    _nodateView.delegate=self;
                    _nodateView.titleText=@"暂无数据";
                    //                    [self.tableView addSubview:_nodateView];
                    _tableview.tableFooterView=_nodateView;
                    _nodateView.noDataButtonIsHidden=NO;
                    //                    _nodateView.nobtnTitle=@"立即设置";
                }
                [self.tableview reloadData];
            }
            else
            {
                if(_nodateView)
                {
                    [_nodateView removeFromSuperview];
                    _nodateView=nil;
                    _tableview.tableFooterView=nil;
                }
                [self.tableview reloadData];
            }
            
            [self.tableview.mj_header endRefreshing];
            [self.tableview.mj_footer endRefreshing];
        }else {
            
            [SVProgressHUD showErrorWithStatus:msg];
            [self.tableview.mj_header endRefreshing];
            [self.tableview.mj_footer endRefreshing];
            [self.tableview reloadData];
            
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark

#pragma mark
-(void)createUI
{
    [self setNav];
    [self.view addSubview:self.tableview];
    [self createheader];
}
- (void)setNav{

    self.title = @"设置";
    self.view.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton)];

    VLXCustomNavTitleView * titleview=[[VLXCustomNavTitleView alloc]initWithFrame:CGRectMake(0, 0, ScaleWidth(222), 30)];
    self.navigationItem.titleView=titleview;
    __block VLXMyOrderVC *blockSelf=self;
    [titleview retuenType:^(NSInteger type) {
        blockSelf.orderType=type+1;
        [blockSelf loadData];


    }];


}
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

#pragma mark 创建header
-(void)createheader
{
    __block VLXMyOrderVC *blockSelf=self;
    VLXOrderHeaderView * headview=[[VLXOrderHeaderView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 44)];
    headview.backgroundColor=[UIColor whiteColor];
    [headview returnBlock:^(NSInteger type) {
        MyLog(@"%ld",type);
        blockSelf.statutType=type+1;
        [blockSelf loadData];
    }];
#pragma mark 中间位置的返回事件
    [self.view addSubview:headview];

}


-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---title no data delegate
-(void)titleButtonNoDataView:(TitleButtonNoDataView *)view didClickButton:(UIButton *)button
{
    NSLog(@"titleButtonNoDataView");
    [self refreshData];
}
#pragma mark
#pragma mark 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArr.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXOrderCarTableViewCell * cell=[VLXOrderCarTableViewCell cellWithTableView:tableView];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (_dataArr&&_dataArr.count>indexPath.row) {
        VLXMyOrderDataModel *dataModel=_dataArr[indexPath.row];
        [cell createUIWithModel:dataModel];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXMyOrderDetailVC *detailVC=[[VLXMyOrderDetailVC alloc] init];
    if (_dataArr&&_dataArr.count>indexPath.row) {
        VLXMyOrderDataModel *dataModel=_dataArr[indexPath.row];
//        detailVC.model=dataModel;
        detailVC.orderID=[NSString stringWithFormat:@"%@",dataModel.orderid];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark 懒加载
-(UITableView * )tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-64-44) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        //刷新
        self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    }

    return _tableview;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
