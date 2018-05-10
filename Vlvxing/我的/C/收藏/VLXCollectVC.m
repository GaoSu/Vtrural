//
//  VLXCollectVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/26.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXCollectVC.h"
#import "VLXcollectModel.h"
#import "VLXPersonDriveCell.h"//自驾游
#import "VLXFarmCourtryCell.h"//农家院
#import "VLXUserCarCell.h"//用车
#import "VLXRouteDetailVC.h"//详情
@interface VLXCollectVC ()<UITableViewDelegate,UITableViewDataSource,TitleButtonNoDataViewDelegate>
@property(nonatomic,strong)NSMutableArray * dataArray;// 用于头部三个选择
@property(nonatomic,strong) UIView * naviView;
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,assign)NSInteger  type;//1.线路  2.农家院 3.用车
//
@property (nonatomic,strong)VLXHomeRecommandModel *recommandModel;
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; //数据源
//
@end

@implementation VLXCollectVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化titleview数据
    self.dataArray=[NSMutableArray array];
    for (int i=0; i<3; i++) {
        VLXcollectModel  * model=[[VLXcollectModel alloc]init];
        model.select=NO;
        if (i==0) {
            model.select=YES;
        }
        [self.dataArray addObject:model];
    }
//初始化cell选择
    //
    _currentPage=1;
    _dataArr=[NSMutableArray array];
    //
    self.type=1;
    [self createUI];
//    [self loadData];

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
    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前所在页，每页展示9个数据
    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
    dic[@"token"]=[NSString getDefaultToken];
    dic[@"type"]=[NSString stringWithFormat:@"%ld",_type];
    NSString * url=[NSString stringWithFormat:@"%@/ProCollectController/auth/getProCollect.json",ftpPath];
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
    [self configThreeTitle];
    [self.view addSubview:self.tableview];
}
- (void)setNav{

//    self.title = @"设置";
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


    self.naviView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 265, 44)];
    self.naviView.backgroundColor=[UIColor whiteColor];
    self.navigationItem.titleView=self.naviView;
    NSArray * titleArray=@[@"线路",@"农家院",@"用车"];
//创建三个view
    for (int i=0; i<3; i++) {

        UIView * detailview=[[UIView alloc]initWithFrame:CGRectMake(i*265/3 + 15, 0, 221/3, 44)];
        detailview.tag=1000+i;
        detailview.backgroundColor=[UIColor whiteColor];
        [self.naviView addSubview:detailview];

        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 221/3, 44)];
        label.text=titleArray[i];
        label.tag=2000+i;

        label.textColor=[UIColor hexStringToColor:@"313131"];
        label.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:19];
        label.textAlignment=NSTextAlignmentCenter;
        [detailview addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(detailview.mas_centerX);
//            make.centerY.mas_equalTo(detailview.mas_centerY);
//            make.width.mas_equalTo(221/3);
//            make.height.mas_equalTo(19);
//        }];
        //创建底部的view
        UIView * bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 42, 221/3, 2)];
        bottomView.backgroundColor=orange_color;
        bottomView.tag=3000+i;
        [detailview addSubview:bottomView];
//        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(0);
//            make.centerX.mas_equalTo(detailview.mas_centerX);
//            make.width.mas_equalTo(18);
//            make.height.mas_equalTo(2);
//
//        }];
        detailview.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changetitleview:)];
        [detailview addGestureRecognizer:tap];


        }


}

-(void)configThreeTitle
{
    for (int i=0; i<3; i++) {
        VLXcollectModel * model=self.dataArray[i];

        UILabel * label=[self.naviView viewWithTag:2000+i];
        MyLog(@"%@",label);
        UIView * oneview=[self.naviView viewWithTag:3000+i];
        if (model.select) {
            label.textColor=orange_color;
            oneview.hidden=NO;
        }else
        {
            label.textColor=[UIColor hexStringToColor:@"313131"];

            oneview.hidden=YES;
        }
    }
}

#pragma mark titleview的点击事件
-(void)changetitleview:(UITapGestureRecognizer * )tap
{
    for (VLXcollectModel * model in self.dataArray) {
        model.select=NO;
    }
    VLXcollectModel * model=self.dataArray[tap.view.tag-1000];
    model.select=YES;


    if (tap.view.tag==1000) {
        MyLog(@"1000");
        self.type=1;
    }else if (tap.view.tag==1001)
    {
        MyLog(@"1001");
        self.type=2;
    }else
    {
        MyLog(@"1002");
        self.type=3;
    }
    [self configThreeTitle];
    [self refreshData];
//    [self.tableview reloadData];
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
#pragma mark tableview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type==1) {
        VLXPersonDriveCell * cell=[tableView dequeueReusableCellWithIdentifier:@"VLXPersonDriveCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
            [cell createUIWithModel:dataModel];
        }
        return cell;

    }else if (self.type==2)
    {
        VLXFarmCourtryCell * farCell=[tableView dequeueReusableCellWithIdentifier:@"VLXFarmCourtryCellID" forIndexPath:indexPath];
        farCell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
            [farCell createUIWithModel:dataModel];
        }
        return farCell;
    }else
    {
        VLXUserCarCell * farCell=[tableView dequeueReusableCellWithIdentifier:@"VLXUserCarCellID" forIndexPath:indexPath];
        farCell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
            [farCell createUIWithModel:dataModel];
        }
        return farCell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
    VLXRouteDetailVC *detailVC=[[VLXRouteDetailVC alloc] init];
    detailVC.detailModel = dataModel;
    detailVC.travelproductID=[NSString stringWithFormat:@"%@",dataModel.travelproductid];
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type==3) {
        return 102;
    }else
    {
          return 191;
    }
}

#pragma mark tableview
-(UITableView * )tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"VLXPersonDriveCell" bundle:nil] forCellReuseIdentifier:@"VLXPersonDriveCellID"];
        [_tableview registerNib:[UINib nibWithNibName:@"VLXFarmCourtryCell" bundle:nil] forCellReuseIdentifier:@"VLXFarmCourtryCellID"];
        [_tableview registerNib:[UINib nibWithNibName:@"VLXUserCarCell" bundle:nil] forCellReuseIdentifier:@"VLXUserCarCellID"];
        //刷新
        self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    }
    return _tableview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  }




@end
