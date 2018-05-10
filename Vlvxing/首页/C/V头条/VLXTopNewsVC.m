//
//  VLXTopNewsVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/5/24.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXTopNewsVC.h"
#import "VLXTopNewsCell.h"
#import "VLXWebViewVC.h"
@interface VLXTopNewsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation VLXTopNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadData];
}
#pragma mark---数据
-(void)loadData
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
#pragma mark
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXTopNewsCell" bundle:nil] forCellReuseIdentifier:@"VLXTopNewsCellID"];
}
- (void)setNav{
    
    self.title = @"V头条";
    self.view.backgroundColor=[UIColor whiteColor];
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
#pragma mark
#pragma mark---事件
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark---delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _vModel.data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXTopNewsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXTopNewsCellID" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (_vModel.data&&_vModel.data.count>indexPath.row) {
        VLXVHeadDataModel *dataModel=_vModel.data[indexPath.row];
        [cell createUIWithModel:dataModel];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXVHeadDataModel *dataModel=_vModel.data[indexPath.row];
    NSLog_JSON(@"dataModel:%@********%@",dataModel,_vModel.data[indexPath.row]);
    VLXWebViewVC *webVC=[[VLXWebViewVC alloc] init];
    webVC.Vmodel = dataModel;
    webVC.shareUrl=[NSString stringWithFormat:@"%@/shareurl/vtopshare.json?vHeadId=%@",ftpPath,dataModel.vheadid]; // 分享链接
    webVC.urlStr = dataModel.vDescription;
    webVC.type=3;
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
