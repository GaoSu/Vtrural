//
//  VLXRouteJudgeChildVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/24.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXRouteJudgeChildVC.h"
#import "VLXRouteJudgeCell.h"
#import "VLXRouteJudgeHeaderView.h"
#import "VLXHomeJudgeModel.h"
@interface VLXRouteJudgeChildVC ()<UITableViewDelegate,UITableViewDataSource,TitleButtonNoDataViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; //
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
@property (nonatomic,strong)VLXHomeJudgeModel *judgeModel;
@property (nonatomic,assign)NSInteger judgeType;//0全部评价 1好评，2中评，3差评
@property (nonatomic,strong)VLXRouteJudgeHeaderView *headerView;
@end

@implementation VLXRouteJudgeChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    //初始化
    _currentPage=1;
    _judgeType=0;
    _dataArr=[NSMutableArray array];
    //
    //
    [self createUI];
    [self loadData];

}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

    [self.tableView reloadData];


}



#pragma mark---数据
-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(void)loadData
{

    [self refreshData];
}
#pragma mark--刷新
-(void)refreshData
{
    self.currentPage=1;
    [self getJudgeProductData:1];
}
#pragma mark--加载
-(void)reloadMoreData
{
    self.currentPage++;
    [self getJudgeProductData:2];
}


#pragma mark
-(void)getJudgeProductData:(int)type//产品评价列表（用车，农家院，自驾游等都可用）
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前所在页，每页展示9个数据
    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
    dic[@"productId"]=[ZYYCustomTool checkNullWithNSString:_productId];//即是每个商品的travelproductid
    dic[@"type"]=[NSString stringWithFormat:@"%ld",_judgeType];//0全部评价 1好评，2中评，3差评
    
    NSString * url=[NSString stringWithFormat:@"%@/ProEvaluateController/productEvaluates.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
//                NSLog(@"%@",requestDic.mj_JSONString);
        _judgeModel=[[VLXHomeJudgeModel alloc] initWithDictionary:requestDic error:nil
                     ];
        if (_judgeModel.status.integerValue == 1) {
            
            [_headerView createUIWithModel:_judgeModel];//刷新头视图
            if (type == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:_judgeModel.data.evaluates];
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
#pragma mark
#pragma mark
#pragma mark---视图
-(void)createUI
{
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self createHeaderView];
    //
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.estimatedRowHeight=50;
    _tableView.rowHeight=UITableViewAutomaticDimension;//高度自适应
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXRouteJudgeCell" bundle:nil] forCellReuseIdentifier:@"VLXRouteJudgeCellID"];
    //
    
    //
}
-(void)createHeaderView
{
    __block VLXRouteJudgeChildVC *blockSelf=self;
    _headerView=[[VLXRouteJudgeHeaderView alloc] initWithFrame:CGRectZero];
    _headerView.judgeBlock=^(NSInteger index)
    {
        NSLog(@"judgeBlock:%ld",index);
        blockSelf.judgeType=index;
        [blockSelf refreshData];
    };
    
}
#pragma mark
#pragma mark---事件
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
    VLXRouteJudgeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXRouteJudgeCellID" forIndexPath:indexPath];


    if (_dataArr&&_dataArr.count>indexPath.row) {
        [cell createUIWithModel:_dataArr[indexPath.row]];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//头尾视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48+8;
}

//


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
