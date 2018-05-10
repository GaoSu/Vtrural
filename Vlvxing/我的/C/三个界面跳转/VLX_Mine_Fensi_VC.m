//
//  VLX_Mine_Fensi_VC.m
//  Vlvxing
//
//  Created by grm on 2018/3/12.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_Mine_Fensi_VC.h"//我的界面里边的粉丝
#import "VLX_mine_fensi_cell.h"
#import "VLX_mine_fensi_model.h"

#import "VLX_other_MainPageVC.h"


@interface VLX_Mine_Fensi_VC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * fensiAry;//主数据
@property(nonatomic,strong)NSMutableArray * fensi_chaunzhiAry;//主数据,传值用

@property (nonatomic,strong) UITableView *tableView2;
@property(nonatomic,assign)int currentPage;//当前页

@end

@implementation VLX_Mine_Fensi_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的粉丝";
    // Do any additional setup after loading the view.
    [self navi_2];
}

-(void)navi_2{//左边按钮
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


    _fensiAry= [NSMutableArray array];
    _fensi_chaunzhiAry = [NSMutableArray array];
    self.tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    //去除多余分割线
    self.tableView2.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //    self.tableView2.backgroundColor = [UIColor redColor];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self.view addSubview: self.tableView2];
    [self loadMain_fansData];
}
-(void)tapLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    VLX_mine_fensi_cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VLX_mine_fensi_cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_fensiAry.count) {
        [cell FillWithModel:_fensiAry[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _fensiAry.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLX_other_MainPageVC * vc = [[VLX_other_MainPageVC alloc]init];
    vc.typee = 0;
    vc.userDic = _fensi_chaunzhiAry[indexPath.row];
    vc.nickNamme = _fensi_chaunzhiAry[indexPath.row][@"usernick"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadMain_fansData{
    NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/home.json"];
    //id=1&type=follows
    NSMutableDictionary * para = [NSMutableDictionary dictionary];


    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *myselfUserId = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];//获取正式的用户id,真实的用户id


    para[@"id"] = myselfUserId;
    para[@"type"]=@"fans";
    NSLog(@"fans参数::::::::::%@",para);
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"fans::::::::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                NSLog(@"dic::::%@",dic);
                VLX_mine_fensi_model * model = [VLX_mine_fensi_model infoListWithDict:dic];
                [_fensiAry addObject:model];
                [_fensi_chaunzhiAry addObject:dic[@"followWhoMember"]];
            }
        }
        [self.tableView2 reloadData];
        [self.tableView2.mj_header endRefreshing];
        [self.tableView2.mj_footer endRefreshing];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}




@end
