//
//  VLXOutSideSpotVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXOutSideSpotVC.h"
#import "VLXNearByHeaderView.h"
#import "VLXDomesticSpotCell.h"
#import "VLXHomeRecommandModel.h"
#import "VLXRouteDetailVC.h"
#import "VLXSearchVC.h"
@interface VLXOutSideSpotVC ()<UITableViewDelegate,UITableViewDataSource,TitleButtonNoDataViewDelegate>
{
    BOOL _isSepcial,_isOrder,_isSelf,_isTheme;//特价 排序 自助 主题
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)VLXNearByHeaderView *selectHeaderView;
//
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; //
@property (nonatomic,strong)VLXHomeRecommandModel *recommandModel;
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
@end

@implementation VLXOutSideSpotVC

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
    dic[@"areaId"]=[NSString stringWithFormat:@"%ld",_areaId];//地区id ， (当查更多时传 -1)
    //
    dic[@"isForeign"]=@"2";//1国内，2国外
    dic[@"isFeature"]=@"0";//0不是特色，1是
    dic[@"isSpecialPrice"]=[NSString stringWithFormat:@"%d",_isSepcial];//0不是特价，1是
    dic[@"isGroup"]=@"0";//0不是跟团，1是
    dic[@"isOrder"]=[NSString stringWithFormat:@"%d",_isOrder];//0不排序，1排序
    dic[@"isSelf"]=[NSString stringWithFormat:@"%d",_isSelf];//0不自助，1自助
    dic[@"isVisa"]=@"0";//0不是免签，1是
    dic[@"isTheme"]=[NSString stringWithFormat:@"%d",_isTheme];//0不主题，1主题
    
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
                    _nodateView=[[TitleButtonNoDataView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kScreenHeight-64-CGRectGetHeight(_selectHeaderView.frame))];
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
    [self createSelectHeaderView];
    //
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXDomesticSpotCell" bundle:nil] forCellReuseIdentifier:@"VLXDomesticSpotCellID"];
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
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
    __block VLXOutSideSpotVC *blockSelf=self;
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
    searchVC.cellType=5;
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
    VLXDomesticSpotCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXDomesticSpotCellID" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (_dataArr&&_dataArr.count>indexPath.row) {
        VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
        [cell createUIWithModel:dataModel];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    VLXHomeRecommandDataModel *model = self.dataArr[indexPath.row];
//    CGFloat height = [model.context sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(ScreenWidth-114, MAXFLOAT)].height;
//    if (height>100) {
//        return 60+height+10;
//    }else{
//        return 100;
//    }

    return 105;
}
//头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return _selectHeaderView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 44+8;
    
}
//尾视图

//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
    VLXRouteDetailVC *detailVC=[[VLXRouteDetailVC alloc] init];
    detailVC.detailModel = dataModel;
    detailVC.travelproductID=[NSString stringWithFormat:@"%@",dataModel.travelproductid];
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
