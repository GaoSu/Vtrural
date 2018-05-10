//
//  VLX_guanzhuVC.m
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_guanzhuVC.h"
#import "UIColor+Tools.h"
#import "VLX_guanzhuModel.h"
#import "VLX_guanzhuCell.h"

#import "VLX_other_MainPageVC.h"


@interface VLX_guanzhuVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * guanzhuAry;
@property(nonatomic,strong)NSMutableArray * guanzhu_chuanzhiAry;//用于传值

@end

@implementation VLX_guanzhuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    _guanzhuAry = [NSMutableArray array];
    _guanzhu_chuanzhiAry = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];



    self.tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-100-39) style:UITableViewStylePlain];
    //去除多余分割线
    self.tableView1.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    [self.view addSubview: self.tableView1];

    [self loadMaindata];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    VLX_guanzhuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VLX_guanzhuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_guanzhuAry.count) {
        [cell FillWithModel:_guanzhuAry[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _guanzhuAry.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VLX_other_MainPageVC * vc = [[VLX_other_MainPageVC alloc]init];
    vc.typee = 0;
    vc.userDic = _guanzhu_chuanzhiAry[indexPath.row];
    vc.nickNamme = _guanzhu_chuanzhiAry[indexPath.row][@"usernick"];

    [self.navigationController pushViewController:vc animated:YES];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.DidScrollBlock) {
        self.DidScrollBlock(scrollView.contentOffset.y);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 数据
-(void)loadMaindata{
    NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/home.json"];
    //id=1&type=follows
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"id"] = _otherID;
    para[@"type"]=@"follows";
    NSLog(@"gz数据参数:%@",para);
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"gz:::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                VLX_guanzhuModel * model = [VLX_guanzhuModel infoListWithDict:dic[@"whoFollowMember"]];
                [_guanzhuAry addObject:model];
                [_guanzhu_chuanzhiAry addObject:dic[@"whoFollowMember"]];
            }

        }

        [self.tableView1 reloadData];

        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];




}

@end
