//
//  VLX_pnglunwodeViewController.m
//  Vlvxing
//
//  Created by grm on 2017/10/30.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_pnglunwodeViewController.h"
#import "VLX_plwdModel.h"
#import "VLX_pinglunwodeTable_ViewCell.h"


@interface VLX_pnglunwodeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * plwdAry;//主数据
@property (nonatomic,strong) UITableView *tableView1;
@property(nonatomic,assign)int currentPage;//当前页

@end

@implementation VLX_pnglunwodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论我的";
    [self setNav];

    self.currentPage = 1;//当前页

    _plwdAry = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];


    self.tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    //去除多余分割线
    self.tableView1.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    [self.view addSubview: self.tableView1];

    [self loadMaindata];

}
- (void)setNav{

    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton1) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton1)];

}

-(void)tapLeftButton1{
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
    VLX_pinglunwodeTable_ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VLX_pinglunwodeTable_ViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_plwdAry.count) {
        [cell FillWithModel:_plwdAry[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _plwdAry.count;
}


-(void)loadMaindata{

    [SVProgressHUD showWithStatus:@""];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
    NSString *myselfUserId = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];//获取正式的用户id,真实的用户id

//    /userfollow/systemMessage.json?currentPage=1&loginUserid=1&type=2
    NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/systemMessage.json"];

    NSMutableDictionary * para = [NSMutableDictionary dictionary];


    para[@"currentPage"] = [NSString stringWithFormat:@"%d",_currentPage];
    para[@"loginUserid"] = myselfUserId;
    para[@"type"]=@1;
    NSLog(@"数据参数:%@",para);
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"gz:::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                VLX_plwdModel * model = [VLX_plwdModel infoListWithDict:dic[@"member"]];
                [_plwdAry addObject:model];
            }

        }

        [self.tableView1 reloadData];

        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];

        [SVProgressHUD dismiss];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];

}


@end
