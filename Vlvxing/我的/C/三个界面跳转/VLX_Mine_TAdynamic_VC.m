//
//  VLX_Mine_TAdynamic_VC.m
//  Vlvxing
//
//  Created by grm on 2018/3/12.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_Mine_TAdynamic_VC.h"//我的界面里边的TA的动态

#import "VLX_mine_TA_model.h"
#import "VLX_mine_TAdynamic_cell.h"

#import "VLX_Community_DetailViewController.h"//帖子详情


@interface VLX_Mine_TAdynamic_VC ()<UITableViewDelegate,UITableViewDataSource>{
    VLX_mine_TA_model * model_ht;
    NSUInteger tttt;
    NSString * myselfUserId;//本人的id
}

@property(nonatomic,strong)NSMutableArray * dynamicAry;//主数据

@property(nonatomic,strong)NSMutableArray * huatiAry_chuanzhi;//传值用
@property(nonatomic,strong)NSMutableArray * huatiUserAry;//每个用户信息
@property(nonatomic,strong)NSMutableArray * huatiDynamicIDAry;//每个帖子的信id

@property (nonatomic,strong) UITableView *tableView3;
@property(nonatomic,assign)int currentPage;//当前页

@end

@implementation VLX_Mine_TAdynamic_VC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoTifShanchushuaxin) name:@"shanchuOKandShuaxin" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我发布的内容";
    // Do any additional setup after loading the view.
    [self navi_3];

    _currentPage = 1;
    _dynamicAry = [NSMutableArray array];
    _huatiAry_chuanzhi = [NSMutableArray array];
    _huatiUserAry = [NSMutableArray array];
    _huatiDynamicIDAry = [NSMutableArray array];

    self.tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    //去除多余分割线
    self.tableView3.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //    self.tableView2.backgroundColor = [UIColor redColor];
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    [self.view addSubview: self.tableView3];
    [self loadMain_huatiData];
}
-(void)navi_3{//左边按钮
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
}
-(void)tapLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 数据
-(void)loadMain_huatiData{


    self.tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas111)];
    [self.tableView3.mj_header beginRefreshing];
    self.tableView3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas111)];


}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dynamicAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第1个列表高度%f",[self.dynamicAry[indexPath.row] CellHeight_ht]);
    return [self.dynamicAry[indexPath.row] CellHeight_ht];//自动计算高度

}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"cell1";
    VLX_mine_TAdynamic_cell * cell = [self.tableView3 dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[VLX_mine_TAdynamic_cell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dynamicAry.count > 0) {
        [cell FillWithModel:_dynamicAry[indexPath.row]];
        [cell.dianzanBt addTarget:self action:@selector(dianzanBt111:) forControlEvents:UIControlEventTouchUpInside];
        cell.dianzanBt.tag = indexPath.row;
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLX_Community_DetailViewController * vc =[[VLX_Community_DetailViewController alloc]init];

    vc.detailDic = self.huatiAry_chuanzhi[indexPath.row];
    vc.userDic   = self.huatiUserAry[indexPath.row];
    vc.dynamic_id = self.huatiDynamicIDAry[indexPath.row];//帖子id
    vc.myselfUserId = myselfUserId;
    vc.typee2 = 1;
    [self.navigationController pushViewController:vc animated:YES];


}
#pragma mark 点赞接口
-(void)dianzanBt111:(UIButton *)sender{
    VLX_mine_TAdynamic_cell *cell = [[VLX_mine_TAdynamic_cell alloc]init];

    UIButton * btn = [[UIButton alloc]init];
    btn = cell.dianzanBt;
    tttt = sender.tag;
    VLX_mine_TA_model * model3 = _dynamicAry[tttt];//找到对应的行号
    if([model3.isFavor isEqual:@0]){//未点赞
        [btn setImage:[UIImage imageNamed:@"like_highlighted"] forState:UIControlStateNormal];
        model3.isFavor = @1;
        [MBProgressHUD showSuccess:@"点赞成功"];
        //        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:tttt inSection:0];
        [self.tableView3 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if([model3.isFavor isEqual:@1]){//已近点赞
        [btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        model3.isFavor = @0;

        [MBProgressHUD showSuccess:@"取消点赞"];

        //一个cell刷新,刷新这一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:tttt inSection:0];
        [self.tableView3 reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    NSString * url3 = [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/favor.json"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"userid"] = myselfUserId;//本人的用户id,不是帖子发布者的id
    dic[@"weiboId"] = model3.dynamicId;//帖子id
    [HMHttpTool get:url3 params:dic success:^(id responseObj) {
        NSLog(@"点赞OK:::%@",responseObj);


    } failure:^(NSError *error) {
        NSLog(@"%@",error);

    }];

}


#pragma  mark 加载最新数据
-(void)loadNewDatas111{

    _currentPage=1;

    if (self.huatiUserAry.count>0) {
        [self.huatiUserAry removeAllObjects];
        [self.huatiAry_chuanzhi removeAllObjects];
        [self.dynamicAry removeAllObjects];
        [self.huatiDynamicIDAry removeAllObjects];
    }
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *myselfUserId = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];//获取正式的用户id,真实的用户id

    NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];

    NSMutableDictionary * paras =[NSMutableDictionary dictionary];
    paras[@"currentPage"] = @(_currentPage);
    paras[@"loginUserid"] = myselfUserId;//自己的id
    paras[@"userid"] = myselfUserId;//_otherID3;//TA 的id
    paras[@"type"]=@4;
    NSLog(@"参数::%@",paras);
    [HMHttpTool get:url params:paras success:^(id responseObj) {
        NSLog_JSON(@"👌L::%@",responseObj);


        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                model_ht = [VLX_mine_TA_model infoListWithDict:dic];
                [self.huatiUserAry addObject:model_ht.member];
                [self.huatiAry_chuanzhi addObject:dic];//向下传值用
                [self.dynamicAry addObject:model_ht];
                [self.huatiDynamicIDAry addObject: model_ht.dynamicId];

            }
            [self.tableView3 reloadData];
            [self.tableView3.mj_footer endRefreshing];
            [self.tableView3.mj_header endRefreshing];
        }

    } failure:^(NSError *error) {
        NSLog(@"✘::::%@",error);
        [self.tableView3.mj_footer endRefreshing];
        [self.tableView3.mj_header endRefreshing];
    }];


}

-(void)loadMoreDatas111{
    [self.tableView3.mj_footer resetNoMoreData];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *myselfUserId = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];//获取正式的用户id,真实的用户id

    NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/weibo/list.json"];

    NSMutableDictionary * paras =[NSMutableDictionary dictionary];
    paras[@"currentPage"] = @(++self.currentPage);
    paras[@"loginUserid"] = myselfUserId;//自己的id
    paras[@"userid"] = myselfUserId;//_otherID3;//TA 的id
    paras[@"type"]=@4;
    NSLog(@"参数::%@",paras);
    [HMHttpTool get:url params:paras success:^(id responseObj) {
        NSLog_JSON(@"👌L::%@",responseObj);


        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                model_ht = [VLX_mine_TA_model infoListWithDict:dic];
                [self.huatiUserAry addObject:model_ht.member];
                [self.huatiAry_chuanzhi addObject:dic];//向下传值用
                [self.dynamicAry addObject:model_ht];
                [self.huatiDynamicIDAry addObject: model_ht.dynamicId];

            }
            [self.tableView3 reloadData];
            [self.tableView3.mj_footer endRefreshing];
            [self.tableView3.mj_header endRefreshing];
            self.tableView3.mj_footer.state = MJRefreshStateNoMoreData;//在没有更多数据时候显示的

        }

    } failure:^(NSError *error) {
        NSLog(@"✘::::%@",error);
        [self.tableView3.mj_footer endRefreshing];
        [self.tableView3.mj_header endRefreshing];
    }];

    

}

//返回到当前界面的时候,
-(void)NoTifShanchushuaxin{
    [self loadNewDatas111];
}


@end
