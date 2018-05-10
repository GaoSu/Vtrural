//
//  VLXSearchResultVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/8.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXSearchResultVC.h"
#import "VLXHomeRecommandCell.h"
#import "VLXRouteDetailVC.h"
#import "VLXPersonDriveCell.h"
#import "VLXFarmCourtryCell.h"
#import "VLXDomesticSpotCell.h"
@interface VLXSearchResultVC ()<UITableViewDelegate,UITableViewDataSource,TitleButtonNoDataViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; //
@property (nonatomic,strong)VLXHomeRecommandModel *recommandModel;
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
@end

@implementation VLXSearchResultVC

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
    [self refreshData];
}
#pragma mark--刷新
-(void)refreshData
{
    self.currentPage=1;
    [self getSearchProductData:1];
}
#pragma mark--加载
-(void)reloadMoreData
{
    self.currentPage++;
    [self getSearchProductData:2];
}
#pragma mark
-(void)getSearchProductData:(int)type//点击国内外时显示的全部商品  或  根据地点获得商品列表
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"isForeign"]= [NSString stringWithFormat:@"%@",_model.isforegin];//1国内，2国外
    dic[@"areaId"]= [NSString stringWithFormat:@"%@",self.model.parentareaid]; // [NSString getAreaID];//地区id
    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前页
    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
    NSString * url=[NSString stringWithFormat:@"%@/ProProductController/productList.html",ftpPath];
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
#pragma mark---视图
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

    
}
-(void)createUI
{
    self.view.backgroundColor=backgroun_view_color;
    [self createNav];
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXHomeRecommandCell" bundle:nil] forCellReuseIdentifier:@"VLXHomeRecommandCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXPersonDriveCell" bundle:nil] forCellReuseIdentifier:@"VLXPersonDriveCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXFarmCourtryCell" bundle:nil] forCellReuseIdentifier:@"VLXFarmCourtryCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXDomesticSpotCell" bundle:nil] forCellReuseIdentifier:@"VLXDomesticSpotCellID"];
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
}
#pragma mark
#pragma mark---事件
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellType==1) {
        VLXHomeRecommandCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXHomeRecommandCellID" forIndexPath:indexPath];
        cell.isHasMargin=NO;
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
            [cell createUIWithModel:dataModel];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (_cellType==2)
    {
        VLXHomeRecommandCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXHomeRecommandCellID" forIndexPath:indexPath];
        cell.isHasMargin=YES;
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
            [cell createUIWithModel:dataModel];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (_cellType==3)
    {
        VLXPersonDriveCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXPersonDriveCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
            [cell createUIWithModel:dataModel];
        }
        return cell;
    }else if (_cellType==4)
    {
        VLXFarmCourtryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXFarmCourtryCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
            [cell createUIWithModel:dataModel];
        }
        return cell;
    }else if (_cellType==5)
    {
        VLXDomesticSpotCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXDomesticSpotCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
            [cell createUIWithModel:dataModel];
        }
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellType==1) {
        return 137+44;
    }else if (_cellType==2)
    {
        return 137+44+8;
    }else if (_cellType==3)
    {
        return 191;
    }else if (_cellType==4)
    {
        return 191;
    }else if (_cellType==5)
    {
        return 92;
    }
    return 0.00001;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
