//
//  VLX_fensiVC.m
//  Vlvxing
//
//  Created by grm on 2018/2/6.
//  Copyright © 2018年 王静雨. All rights reserved.
//

#import "VLX_fensiVC.h"

#import "UIColor+Tools.h"
#import "VLX_fansModel.h"
#import "VLX_fansCell.h"


#import "VLX_other_MainPageVC.h"


@interface VLX_fensiVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * fansAry;
@property(nonatomic,strong)NSMutableArray * fans_chaunzhiAry;//用于传值


@end

@implementation VLX_fensiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fansAry= [NSMutableArray array];
    _fans_chaunzhiAry= [NSMutableArray array];
    self.tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-100-39-150) style:UITableViewStylePlain];
    //去除多余分割线
    self.tableView2.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    self.tableView2.backgroundColor = [UIColor redColor];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self.view addSubview: self.tableView2];
    [self loadMain_fansData];


    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    VLX_fansCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VLX_fansCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_fansAry.count) {
        [cell FillWithModel:_fansAry[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _fansAry.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VLX_other_MainPageVC * vc = [[VLX_other_MainPageVC alloc]init];
    vc.typee = 0;
    vc.userDic = _fans_chaunzhiAry[indexPath.row];
    vc.nickNamme = _fans_chaunzhiAry[indexPath.row][@"usernick"];
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
-(void)loadMain_fansData{
    NSString * url= [NSString stringWithFormat:@"%@%@",tang_BENDIJIEKOU_URL,@"/userfollow/home.json"];
    //id=1&type=follows
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    if(_otherID2 == nil){
        NSLog(@"zhende");//跑了
    }
    para[@"id"] = _otherID2;
    para[@"type"]=@"fans";
    NSLog(@"fans参数::::::::::%@",para);
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"fans::::::::::%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            for (NSDictionary * dic in responseObj[@"data"]) {
                NSLog(@"dic::::%@",dic);
                VLX_fansModel * model = [VLX_fansModel infoListWithDict:dic];
                [_fansAry addObject:model];
                [_fans_chaunzhiAry addObject:dic[@"followWhoMember"]];
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
