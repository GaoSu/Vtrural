//
//  VLX_Mine_GZ_Vc.m
//  Vlvxing
//
//  Created by grm on 2018/3/12.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_Mine_GZ_Vc.h"//我的界面里边的关注
#import "VLX_mine_gz_Cell.h"
#import "VLX_mine_gz_Model.h"

#import "VLX_other_MainPageVC.h"

@interface VLX_Mine_GZ_Vc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray * gzAry;//主数据
@property(nonatomic,strong)NSMutableArray * gz_chuanzhiAry;//主数据,用于传值

@property (nonatomic,strong) UITableView *tableView1;
//当前页
@property (nonatomic,assign) NSInteger pageIndex_Mgz;

@end

@implementation VLX_Mine_GZ_Vc

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我关注的人";
    _gzAry=[NSMutableArray array];
    _gz_chuanzhiAry = [NSMutableArray array];

//    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    //去除多余分割线
    self.tableView1.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMaindata)];
    self.tableView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    self.automaticallyAdjustsScrollViewInsets = NO;

    //以下三行代码,可以解决ios11,上拉加载更多那个小菊花不能停下来的问题
    self.tableView1.estimatedRowHeight = 0;
    self.tableView1.estimatedSectionHeaderHeight = 0;
    self.tableView1.estimatedSectionFooterHeight = 0;


//    if (@available(iOS 11.0, *)) {
//        _tableView1.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        _tableView1.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
//        _tableView1.scrollIndicatorInsets = _tableView1.contentInset;
//    }
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;


    [self.view addSubview: self.tableView1];

    [self navi];
    [self loadMaindata];//不然开始进来会没数据

}
//-(void)loadtablevwData{
////    self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMaindata)];
////
//////    if (@available(iOS 11.0, *)) {
//////        _tableView1.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//////        _tableView1.contentInset = UIEdgeInsetsMake(-27.5, 0, 49, 0);
//////        _tableView1.scrollIndicatorInsets = _tableView1.contentInset;
//////    }
////
////    self.tableView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
////    //以下三行代码,可以解决ios11,上拉加载更多那个小菊花不能停下来的问题
////    self.tableView1.estimatedRowHeight = 0;
////    self.tableView1.estimatedSectionHeaderHeight = 0;
////    self.tableView1.estimatedSectionFooterHeight = 0;
//
//}
-(void)navi{//左边按钮
//UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//leftBtn.frame = CGRectMake(0, 0, 20, 20);
//[leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//[leftBtn addTarget:self action:@selector(tapLeftButton) forControlEvents:UIControlEventTouchUpInside];
//UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton)];
}
-(void)tapLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    VLX_mine_gz_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VLX_mine_gz_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_gzAry.count) {
        [cell FillWithModel:_gzAry[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _gzAry.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLX_other_MainPageVC * vc = [[VLX_other_MainPageVC alloc]init];
    vc.typee = 0;
    vc.userDic = _gz_chuanzhiAry[indexPath.row];
    vc.nickNamme = _gz_chuanzhiAry[indexPath.row][@"usernick"];

    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loadMaindata{
    _pageIndex_Mgz = 1;

    if (_gzAry.count>0) {
        [_gzAry removeAllObjects];
        [_gz_chuanzhiAry removeAllObjects];
    }
    NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/home.json"];
    //id=1&type=follows
    NSMutableDictionary * para = [NSMutableDictionary dictionary];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *myselfUserId = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];//获取正式的用户id,真实的用户id
//    params[@"currentPage"] = @(++self.pageIndex_OHT);

    para[@"currentPage"] = @(_pageIndex_Mgz);
    para[@"id"] = myselfUserId;
    para[@"type"]=@"follows";
    NSLog(@"mine_gz数据参数:%@",para);
    [HMHttpTool get:url params:para success:^(id responseObj) {


        NSLog_JSON(@"mine_gz:::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                VLX_mine_gz_Model * model = [VLX_mine_gz_Model infoListWithDict:dic[@"whoFollowMember"]];
                [_gzAry addObject:model];
                [_gz_chuanzhiAry addObject:dic[@"whoFollowMember"]];
            }
        }



        [self.tableView1 reloadData];
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];



    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];


}




-(void)loadMoreData{

    [self.tableView1.mj_footer resetNoMoreData];

    NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/home.json"];
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *myselfUserId = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];//获取正式的用户id,真实的用户id

    para[@"currentPage"] = @(++self.pageIndex_Mgz);
    para[@"id"] = myselfUserId;
    para[@"type"]=@"follows";
    NSLog(@"mine_gz数据参数:%@",para);
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"mine_gz:::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                VLX_mine_gz_Model * model = [VLX_mine_gz_Model infoListWithDict:dic[@"whoFollowMember"]];
                [_gzAry addObject:model];
                [_gz_chuanzhiAry addObject:dic[@"whoFollowMember"]];
            }
        }
        [self.tableView1 reloadData];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    [self.tableView1.mj_header endRefreshing];
    [self.tableView1.mj_footer endRefreshing];

    self.tableView1.mj_footer.state = MJRefreshStateNoMoreData;//在没有更多数据时候显示的

}

@end
