//
//  VLXMessageCenterVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMessageCenterVC.h"
#import "VLXMessageCenterCell.h"
#import "VLXOrderMessageVC.h"//订单
#import "VLXSystemMessageVC.h"//系统消息
#import "VLXHomeMessageModel.h"


#import "VLX_orderMessage_VC.h"//订单
#import "VLX_systemMessage_VC.h"//系统消息

@interface VLXMessageCenterVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)VLXHomeMessageModel *messageModel;
@end

@implementation VLXMessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
//    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

-(void)loadData
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    
    dic[@"token"]=[NSString getDefaultToken];//
    NSString * url=[NSString stringWithFormat:@"%@/sysMsg/auth/getSysMsgCountByMsgstatus.json",ftpPath];
    
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog(@"消息列表数据%@",requestDic.mj_JSONString);
        _messageModel=[[VLXHomeMessageModel alloc] initWithDictionary:requestDic error:nil];
        if (_messageModel.status.integerValue==1) {
            [self.tableview reloadData];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)createUI
{
    [self setNav];
    [self.view addSubview:self.tableview];
}
- (void)setNav{

    self.title = @"消息中心";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//iOS 11.2以后,分组的头和尾部的frame会变大,所以需要加上这两个方法,让头和尾部的view从视觉上看是正常
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

#pragma mark代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXHomeMessageDataModel *model=_messageModel.data[indexPath.section];
    CGFloat height = [model.messageText sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth-83, MAXFLOAT)].height;
    if (height == 0) {
       return 76-14+height+15;
    }
    
    return 76-14+height;
    
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    VLXMessageCenterCell * cell=[VLXMessageCenterCell cellWithTableView:tableView];
    if (_messageModel.data&&_messageModel.data.count>indexPath.row) {
        VLXHomeMessageDataModel *model=_messageModel.data[indexPath.section];
        [cell createUIWithModel:model];
    }
//    if (indexPath.section==0) {
////        cell.leftimagmeview.image=[UIImage imageNamed:@"xitongmoren"];
//
//    }else
//    {
////        cell.topleftlabel.text=@"订单消息";
//    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        VLXSystemMessageVC * system=[[VLXSystemMessageVC alloc]init];
        [self.navigationController pushViewController:system animated:YES];

    }else
    {
        VLXOrderMessageVC * order=[[VLXOrderMessageVC alloc]init];
        [self.navigationController pushViewController:order animated:YES];
//        VLX_orderMessage_VC * order = [[VLX_orderMessage_VC alloc]init];
//        [self.navigationController pushViewController:order animated:YES];
    }

    
}

#pragma mark 懒加载
-(UITableView * )tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    }


    return _tableview;
}


@end
