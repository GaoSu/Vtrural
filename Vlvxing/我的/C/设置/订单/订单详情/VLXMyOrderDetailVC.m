//
//  VLXMyOrderDetailVC.m
//  Vlvxing
//
//  Created by 王静雨 on 2017/6/5.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXMyOrderDetailVC.h"
#import "VLXOrderHeaderCell.h"
#import "VLXOrderDetailCell.h"
#import "VLXOrderFooterView.h"
#import "VLXJudgeForOrderVC.h"//评价
#import "VLXPayCustomAlertView.h"
#import "VLXOrderDetailModel.h"
@interface VLXMyOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)VLXOrderFooterView *footView;
@property (nonatomic,strong)UILabel *statusLab;
@property (nonatomic,strong)VLXOrderDetailModel *detailModel;
@end

@implementation VLXMyOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadData];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addNotification];

    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"token"]=[NSString getDefaultToken];
    dic[@"orderId"]=[ZYYCustomTool checkNullWithNSString:_orderID];//订单id
    NSString * url=[NSString stringWithFormat:@"%@/OrderInfoController/auth/getOrderInfo.html",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",requestDic.mj_JSONString);
        _detailModel=[[VLXOrderDetailModel alloc] initWithDictionary:requestDic error:nil];
        if ([requestDic[@"status"] integerValue]==1) {

            NSLog(@"grm_message:%@",_detailModel.data);//
            //引入
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }


    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];

    }];

}
-(void)viewDidDisappear:(BOOL)animated
{
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXPayNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AliPayNotification" object:nil];
    
}
//支付结果通知
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWXPayResult:) name:@"WXPayNotification" object:nil];//监听一个通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAliPayResult:) name:@"AliPayNotification" object:nil];//监听一个通知
}
#pragma mark 微信.  支付宝  结果通知
- (void)getWXPayResult:(NSNotification *)sender
{
    [SVProgressHUD dismiss];
    NSString *result = sender.object;
    if ([result isEqualToString:@"success"])
    {
         NSLog(@"郭荣明_支付测试OK_002");
        [SVProgressHUD showSuccessWithStatus:@"支付成功!"];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
         NSLog(@"郭荣明_支付测试 失败_002");
        [SVProgressHUD showErrorWithStatus:@"支付失败，请重试"];
    }
}
- (void)getAliPayResult:(NSNotification *)sender
{
//    [SVProgressHUD dismiss];
    NSDictionary *resultDic = sender.userInfo;
    //MyLog(@"AlipaySDK reslut = %@",resultDic);
    if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000)
    {
         NSLog(@"郭荣明_支付测试_ok_003");
        [SVProgressHUD showSuccessWithStatus:@"支付成功!"];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             NSLog(@"郭荣明_支付测试_失败_003");
            [SVProgressHUD showErrorWithStatus:@"支付失败，请重试"];
        });
        
//        [MBProgressHUD ]
    }
}
#pragma mark
#pragma mark---数据
-(void)loadData//获取订单详情
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"token"]=[NSString getDefaultToken];
    dic[@"orderId"]=[ZYYCustomTool checkNullWithNSString:_orderID];//订单id
    NSString * url=[NSString stringWithFormat:@"%@/OrderInfoController/auth/getOrderInfo.html",ftpPath];
    NSLog(@"%@",dic);
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",requestDic.mj_JSONString);
        _detailModel=[[VLXOrderDetailModel alloc] initWithDictionary:requestDic error:nil];
        if ([requestDic[@"status"] integerValue]==1) {
            [self createHeaderView];
            [self createFooterView];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)loadDataWithCancelOrder//取消订单
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"token"]=[NSString getDefaultToken];
    dic[@"orderId"]=[NSString stringWithFormat:@"%@",_detailModel.data.orderid];//订单id
    NSString * url=[NSString stringWithFormat:@"%@/OrderInfoController/auth/deleteOrder.html",ftpPath];
    NSLog(@"%@",dic);
    [SVProgressHUD showWithStatus:@"正在取消"];
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        if ([requestDic[@"status"] integerValue]==1) {
            [SVProgressHUD showSuccessWithStatus:@"订单已取消"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }

        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark
#pragma mark---视图
-(void)createUI
{
    [self setNav];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.estimatedRowHeight=50;
    _tableView.rowHeight=UITableViewAutomaticDimension;//高度自适应
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"VLXOrderHeaderCell" bundle:nil] forCellReuseIdentifier:@"VLXOrderHeaderCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VLXOrderDetailCell" bundle:nil] forCellReuseIdentifier:@"VLXOrderDetailCellID"];
    //
}
- (void)setNav{
    
    self.title = @"订单详情";
    self.view.backgroundColor=[UIColor hexStringToColor:@"f3f3f4"];
    //左边按钮
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
-(void)createHeaderView
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    headerView.backgroundColor=[UIColor whiteColor];
    _statusLab=[[UILabel alloc] initWithFrame:CGRectMake(11, 0, 200, 44)];
    if (_detailModel.data.orderstatus.integerValue==0) {//0 待支付 1 已支付，2已评价,3已取消
        _statusLab.text=@"订单状态: 待付款";
    }else if (_detailModel.data.orderstatus.integerValue==1)
    {
        _statusLab.text=@"订单状态: 已付款";
    }else if (_detailModel.data.orderstatus.integerValue==2)
    {
        _statusLab.text=@"订单状态: 已评价";
    }else if (_detailModel.data.orderstatus.integerValue==3)
    {
        _statusLab.text=@"订单状态: 已取消";
    }
    _statusLab.font=[UIFont systemFontOfSize:16];
    _statusLab.textColor=[UIColor hexStringToColor:@"#313131"];
    _statusLab.textAlignment=NSTextAlignmentLeft;
    [headerView addSubview:_statusLab];
    _tableView.tableHeaderView=headerView;
    
}
-(void)createFooterView
{
    if (_detailModel.data.orderstatus.integerValue==2||_detailModel.data.orderstatus.integerValue==3) {
        return;
    }
    __block VLXMyOrderDetailVC *blockSelf=self;
    _footView=[[VLXOrderFooterView alloc] initWithFrame:CGRectZero andType:_detailModel.data.orderstatus.integerValue andPrice:[NSString stringWithFormat:@"%@",_detailModel.data.orderallprice]];////0 待支付 1 已支付，2已评价,3已取消
    self.tableView.tableFooterView=_footView;
    _footView.btnBlock=^(NSInteger index)
    {
        switch (index) {
            case 0:
            {
                NSLog(@"取消订单");
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定取消订单吗?" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"确定");

                    [blockSelf loadDataWithCancelOrder];
                    
                }];
                UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"取消");
                }];
                [alertC addAction:alertA];
                [alertC addAction:alertB];
                [blockSelf presentViewController:alertC animated:YES completion:nil];
                
                
            }
                break;
            case 1:
            {
                NSLog(@"立即支付");
                VLXPayCustomAlertView *payAlert=[[VLXPayCustomAlertView alloc] initWithFrame:CGRectZero andPayMoney:blockSelf.detailModel.data.orderallprice.floatValue];
                //test
//                float allPrice=0.01;
                //
                //prodution
                float allPrice=blockSelf.detailModel.data.orderallprice.floatValue;
                //
                [[UIApplication sharedApplication].keyWindow addSubview:payAlert];
                payAlert.payTypeBlock=^(NSInteger tag)
                {
                    if (tag==0) {
                        NSLog(@"微信");

                        
                        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
                        dataDic[@"token"]=[NSString getDefaultToken];
                        dataDic[@"orderid"]=[NSString stringWithFormat:@"%@",blockSelf.detailModel.data.orderid];//
                        dataDic[@"systemtradeno"]=[NSString stringWithFormat:@"%@",blockSelf.detailModel.data.systemtradeno];
                        dataDic[@"orderprice"]=[NSString stringWithFormat:@"%f",allPrice];//单位:元
                        NSLog(@"%@",dataDic);
                        [[PayTool defaltTool] payForServiceWithDic:dataDic withViewController:blockSelf withPayType:@"101" SuccessBlock:^{
                            NSLog(@"SuccessBlock");
                        } failure:^(NSString *errorInfo) {
                            NSLog(@"failure:%@",errorInfo);
                        }];
                    }else if (tag==1)
                    {
                        NSLog(@"支付宝");
          
                        
                        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
                        dataDic[@"token"]=[NSString getDefaultToken];
                        dataDic[@"orderid"]=[NSString stringWithFormat:@"%@",blockSelf.detailModel.data.orderid];
                        dataDic[@"systemtradeno"]=[NSString stringWithFormat:@"%@",blockSelf.detailModel.data.systemtradeno];
                        dataDic[@"orderprice"]=[NSString stringWithFormat:@"%f",allPrice];//单位:元
                        dataDic[@"servername"]=[ZYYCustomTool checkNullWithNSString:blockSelf.detailModel.data.ordername];
                        NSLog(@"%@",dataDic);
                        [[PayTool defaltTool] payForServiceWithDic:dataDic withViewController:blockSelf withPayType:@"102" SuccessBlock:^{
                            NSLog(@"SuccessBlock");
                        } failure:^(NSString *errorInfo) {
                            NSLog(@"failure:%@",errorInfo);
                        }];
                    }
                };
            }
                break;
            case 2:
            {
                NSLog(@"去评价");
                VLXJudgeForOrderVC *judgeVC=[[VLXJudgeForOrderVC alloc] init];
                judgeVC.orderId=[NSString stringWithFormat:@"%@",blockSelf.detailModel.data.orderid];
                judgeVC.productId=[NSString stringWithFormat:@"%@",blockSelf.detailModel.data.travelproductid];
                [blockSelf.navigationController pushViewController:judgeVC animated:YES];
            }
                break;
            default:
                break;
        }
    };
}
#pragma mark
#pragma mark---事件
-(void)tapLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark---delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        VLXOrderHeaderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXOrderHeaderCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell createUIWithModel:_detailModel.data];
        return cell;
    }else if (indexPath.row==1)
    {
        VLXOrderDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VLXOrderDetailCellID" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell createUIWithModel:_detailModel.data];
        return cell;
    }
    return nil;
    
}
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
