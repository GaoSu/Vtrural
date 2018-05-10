//
//  VLXOutSideVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/23.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXOutSideVC.h"
#import "VLXHomeRecommandCell.h"
#import "VLXNearByHeaderView.h"
#import "VLXDomesticHotCell.h"
#import "VLXOutSideSpotVC.h"
#import "VLXHomeAdsModel.h"
#import "VLXHomeRecommandModel.h"
#import "VLXRouteDetailVC.h"
#import "VLXCityChooseVC.h"
#import "VLXSearchVC.h"
#import "VLXWebViewVC.h"
@interface VLXOutSideVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TitleButtonNoDataViewDelegate>
{
    BOOL _isFeature,_isSpecial,_isGroup,_isOrder;//特色 特价 跟团 排序
}
@property  (nonatomic,strong)UILabel *cityLab;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)SDCycleScrollView *adScrollView;//广告轮播图
@property (nonatomic,strong)VLXNearByHeaderView *selectHeaderView;
@property (nonatomic,strong)NSMutableArray *hotArray;
//数据
@property (nonatomic,strong)VLXHomeAdsModel *adsModel;//广告轮播图数据
@property (nonatomic,strong)VLXHotDemesticModel *hotDemesticModel;//热门景点数据
@property (nonatomic,strong)VLXHomeRecommandModel *recommandModel;//列表 数据
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; // 存放当季游玩 热门推荐数据
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
//
@end

@implementation VLXOutSideVC
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
    //test
//    _hotArray=[NSMutableArray arrayWithObjects:@"奥沙利文",@"英国",@"特鲁姆普",@"法国",@"小李子",@"澳大利亚", nil];
    //初始化
    _hotArray=[NSMutableArray array];
    _currentPage=1;
    _dataArr=[NSMutableArray array];
    //
    //
    [self creaeteUI];
    [self loadData];
}
#pragma mark---数据
-(void)loadData
{
//    _adScrollView.localizationImageNamesGroup=@[@"guanggao",@"qicheguanggao",@"qicheguanggao"];
    [self loadADData];
    [self loadHotDomesticData];
    [self refreshData];
}
-(void)loadADData//轮播图数据
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"categoryId"]=@"2";//分类id(0:首页，1国内，2国外，3附近)
    NSString * url=[NSString stringWithFormat:@"%@/SysAdController/getSlideShow.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog_JSON(@"轮播图👌:%@",requestDic);
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
-(void)loadHotDomesticData//获取热门景点数据
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"isForegin"]=@"2";//1国内，2国外
    NSString * url=[NSString stringWithFormat:@"%@/ProSpotsController/getProSpots.html",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        _hotDemesticModel=[[VLXHotDemesticModel alloc] initWithDictionary:requestDic error:nil];
        if (_hotDemesticModel.status.integerValue==1) {
            _hotArray=[NSMutableArray arrayWithArray:_hotDemesticModel.data];
            [self.tableView reloadData];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)loadRecommandData:(int )type//点击国内外时显示的全部商品  或  根据地点获得商品列表
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前所在页，每页展示9个数据
    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
//    dic[@"areaId"]=@"110100";//地区id ， (当查更多时传 -1)
//    dic[@"areaId"]=[NSString getAreaID];//地区id
    //
    dic[@"isForeign"]=@"2";//1国内，2国外
    dic[@"isFeature"]=[NSString stringWithFormat:@"%d",_isFeature];//0不是特色，1是
    dic[@"isSpecialPrice"]=[NSString stringWithFormat:@"%d",_isSpecial];//0不是特价，1是
    dic[@"isGroup"]=[NSString stringWithFormat:@"%d",_isGroup];//0不是跟团，1是
    dic[@"isOrder"]=[NSString stringWithFormat:@"%d",_isOrder];//0不排序，1排序
    dic[@"isSelf"]=@"0";//0不自助，1自助
    dic[@"isVisa"]=@"0";//0不是免签，1是
    dic[@"isTheme"]=@"0";//0不主题，1主题
    NSString * url=[NSString stringWithFormat:@"%@/ProProductController/productList.html",ftpPath];
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog(@"列表👌:%@",requestDic);
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
//
//
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
    [self loadRecommandData:1];
}
#pragma mark--加载
-(void)reloadMoreData
{
    self.currentPage++;
    [self loadRecommandData:2];
}

#pragma mark
#pragma mark---视图
-(void)creaeteUI
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
    [_tableView registerNib:[UINib nibWithNibName:@"VLXHomeRecommandCell" bundle:nil] forCellReuseIdentifier:@"VLXHomeRecommandCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXDomesticHotCell" bundle:nil] forCellReuseIdentifier:@"VLXDomesticHotCellID"];
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
//-(void)createNav
//{
//    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;
//    //中间
//    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 7, kScreenWidth-80, 30)];
//    titleView.layer.cornerRadius=4;
//    titleView.layer.masksToBounds=YES;
//    titleView.layer.borderColor=orange_color.CGColor;
//    titleView.layer.borderWidth=1;
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:titleView];
//    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(11, (30-17)/2, 17, 17)];
//    [imageView setImage:[UIImage imageNamed:@"search"]];
//    [titleView addSubview:imageView];
//    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, 0, 120, 30)];
//    titleLab.text=@"请输入关键词搜索";
//    titleLab.textColor=[UIColor hexStringToColor:@"#999999"];
//    titleLab.font=[UIFont systemFontOfSize:14];
//    titleLab.textAlignment=NSTextAlignmentLeft;
//    [titleView addSubview:titleLab];
//    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(titleView.frame)-70, 3, 0.5, 30-3*2)];
//    line.backgroundColor=orange_color;
//    [titleView addSubview:line];
//    //
//    CGFloat cityHeight=14;
//    CGFloat margin=(CGRectGetWidth(titleView.frame)-CGRectGetMaxX(line.frame)-45)/2;
//    UIView *cityView=[[UIView alloc] initWithFrame:CGRectMake(margin+CGRectGetMaxX(line.frame), (30-cityHeight)/2, 45, cityHeight)];
//    
//    _cityLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, cityHeight)];
//    _cityLab.text=[NSString getCity];
//    _cityLab.font=[UIFont systemFontOfSize:14];
//    _cityLab.textAlignment=NSTextAlignmentCenter;
//    [cityView addSubview:_cityLab];
//    UIImageView *imageView1=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cityLab.frame)+3, (cityHeight-4)/2, 7, 4)];
//    [imageView1 setImage:[UIImage imageNamed:@"pull-down"]];
//    [cityView addSubview:imageView1];
//    [titleView addSubview:cityView];
//    //添加手势
//    //
//    cityView.userInteractionEnabled=YES;
//    UITapGestureRecognizer *cityTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToChooseCity:)];
//    [cityView addGestureRecognizer:cityTap];
//    //
//    titleView.userInteractionEnabled=YES;
//    UITapGestureRecognizer *centerTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerNavItemClicked:)];
//    [titleView addGestureRecognizer:centerTap];
//}
-(void)createSelectHeaderView
{
    __block VLXOutSideVC *blockSelf=self;
    _selectHeaderView=[[VLXNearByHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andTitleArray:@[@"全部",@"特色",@"特价",@"跟团",@"排序"]];
    _selectHeaderView.nearBlock=^(NSInteger index)
    {
        //重置
        _isFeature=NO;
        _isSpecial=NO;
        _isGroup=NO;
        _isOrder=NO;
        if (index==0) {//
            
        }else if (index==1)//
        {
            _isFeature=YES;
        }else if (index==2)//
        {
            _isSpecial=YES;
        }else if (index==3)//
        {
            _isGroup=YES;
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
    searchVC.cellType=2;
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)tapToChooseCity:(UITapGestureRecognizer *)tap
{
    NSLog(@"tapToChooseCity");
    __block VLXOutSideVC *blockSelf=self;
    VLXCityChooseVC * city=[[VLXCityChooseVC alloc]init];
    [self.navigationController pushViewController:city animated:YES];

}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSMutableArray *imageUrlArr=[NSMutableArray array];
    NSMutableArray *titleArr=[NSMutableArray array];
    for (VLXHomeAdsDataModel *dataModel in _adsModel.data) {
        [imageUrlArr addObject:[ZYYCustomTool checkNullWithNSString:dataModel.adcontents]];
        [titleArr addObject:[ZYYCustomTool checkNullWithNSString:dataModel.adtitle]];
        NSLog(@"adcontents:%@``%@``%@",dataModel.adcontents,dataModel.adtitle,dataModel.adpostion);//,adtitle,adpostion
//adcontents=http://app.mtvlx.cn/lvyoushejiao/shareurl/farmstayscheduleshare.json?travelProductId=117
//dataModel.adtitle= 欧洲
//dataModel.adpostion=1
    }
    NSString *urlStr = imageUrlArr[index];
    NSString * title = titleArr[index];
    VLXWebViewVC *webView = [[VLXWebViewVC alloc]init];
    webView.urlStr = urlStr;
    webView.type = 4;
    webView.adTitle = title;
    [self.navigationController pushViewController:webView animated:YES];
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
    
    if (indexPath.section==0) {
        VLXDomesticHotCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXDomesticHotCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_hotArray&&_hotArray.count>indexPath.row) {
            [cell createUIWithData:_hotArray andType:2];
        }
//        [cell createUIWithData:_hotArray andType:2];
        //回调
        __block VLXOutSideVC *blockSelf=self;
        cell.hotBlock=^(NSInteger tag,BOOL isMore)
        {
            NSLog(@"%ld",tag);
            VLXOutSideSpotVC *spotVC=[[VLXOutSideSpotVC alloc] init];
            if (isMore) {
                spotVC.areaId=-1;
            }else
            {
                VLXHotDemesticDataModel *dataModel= _hotDemesticModel.data[tag];
                spotVC.areaId=dataModel.areaid.integerValue;
            }
            [blockSelf.navigationController pushViewController:spotVC animated:YES];
        };
        return cell;
    }
    else if (indexPath.section==1)
    {
        VLXHomeRecommandCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXHomeRecommandCellID" forIndexPath:indexPath];
        cell.isHasMargin=YES;
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
    if (indexPath.section==0) {
        //        NSLog(@"%f",44+(_hotArray.count/4+1)*(ScaleWidth(80)+10)+10);
        return 44+(_hotArray.count/4+1)*(ScaleWidth(80)+10)+10;
        
    }
    else if (indexPath.section==1)
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
//尾视图

//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        VLXHomeRecommandDataModel *dataModel=_dataArr[indexPath.row];
        VLXRouteDetailVC *detailVC=[[VLXRouteDetailVC alloc] init];
        detailVC.travelproductID=[NSString stringWithFormat:@"%@",dataModel.travelproductid];
        detailVC.detailModel = dataModel;
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
