
//
//  VLX_orderMessage_VC.m
//  Vlvxing
//
//  Created by grm on 2017/12/12.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_orderMessage_VC.h"
#import "VLX_system_Order_Model.h"
#import "VLX_system_order_Cell.h"

#import "VLXMyOrderDetailVC.h"     //线路订单详情
#import "VLX_myOrderDetailVC_new.h"//机票订单详情
@interface VLX_orderMessage_VC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * tabArray;//列表数据
    NSMutableArray * orderIDArray;//订单id数组
    NSMutableArray * order_idAry;//订单id

    

}
@property (nonatomic, strong)UITableView * tableVW2;
@property(nonatomic,assign)int currentPage;//当前页

@end

@implementation VLX_orderMessage_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [super viewDidLoad];
    self.title = @"订单";

    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton3) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton3)];

    tabArray = [NSMutableArray array];
    orderIDArray = [NSMutableArray array];

    order_idAry = [NSMutableArray array];

    _currentPage = 1;



    [self lodaData_Order];

    [self makeUI];

}
-(void)tapLeftButton3
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)makeUI{

    _tableVW2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];

    _tableVW2 .delegate = self;
    _tableVW2. dataSource = self;
    //去除多余分割线
    _tableVW2.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //刷新
    _tableVW2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _tableVW2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];


    [self.view addSubview:_tableVW2];

}
-(void)refreshData{


    [tabArray removeAllObjects];//清空数据源
    _currentPage = 1;
    [self lodaData_Order];
}
-(void)reloadMoreData{
    _currentPage ++;
    [self lodaData_Order];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return tabArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 196/2;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    if(_tableVW2 == tableView)
    {
        static NSString *ID = @"cell";

        VLX_system_order_Cell *cell = [_tableVW2 dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[VLX_system_order_Cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        if (tabArray.count > 0) {
            [cell FillWithModel:tabArray[indexPath.row]];

        }
        return cell;
    }

    return nil;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_SERIAL, 0), ^{
        if (tabArray&&tabArray.count>indexPath.row) {
            VLX_system_Order_Model *dataModel=tabArray[indexPath.section];
            [self changeMessageStatusWithMsgid:[NSString stringWithFormat:@"%@",dataModel.msgid]];


        }
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            VLXMyOrderDetailVC *detailVC=[[VLXMyOrderDetailVC alloc] init];
            if (tabArray&&tabArray.count>indexPath.row) {
//                VLXMessageDataModel *dataModel=tabArray[indexPath.section];
//                detailVC.orderID=[NSString stringWithFormat:@"%@",dataModel.orderid];
            }
            [self.navigationController pushViewController:detailVC animated:YES];
        });
    });
}
#pragma 左划删除左滑删除
//左划删除的两个方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    editingStyle = UITableViewCellEditingStyleDelete;//此处的EditingStyle可等于任意UITableViewCellEditingStyle，该行代码只在iOS8.0以前版本有作用，也可以不实现。


}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除订单" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义

        if(tabArray.count > 0){
            //1后台删除
            NSMutableDictionary * para = [NSMutableDictionary dictionary];
            NSString * paraID = orderIDArray[ indexPath.row];
            NSLog(@"paraid%@",paraID);
            para[@"orderId"] = paraID;
            NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"deleteByOrderState"];//
            [HMHttpTool get:url params:para success:^(id responseObj) {
                NSLog_JSON(@"成功删除%@",responseObj);
            } failure:^(NSError *error) {
                NSLog_JSON(@"删除失败%@",error);
            }];
            //2本地数据删除
            [tabArray removeObjectAtIndex:indexPath.row];
            //3UI删除
            [_tableVW2 deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            NSLog(@"点击删除");
        }
    }];


    deleteRoWAction.backgroundColor = [UIColor colorWithRed:243/255.0 green:77/255.0 blue:66/255.0 alpha:1];//主色

    return @[deleteRoWAction];

}

-(void)lodaData_Order
{
        NSString * url = [NSString stringWithFormat:@"%@/sysMsg/auth/getsysmsglist.json",ftpPath];
        NSMutableDictionary * para = [NSMutableDictionary dictionary];

        para[@"token"]=[NSString getDefaultToken];
        para[@"msgType"]=@"2";//消息类型  1：系统消息，2：通知消息
        para[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前所在页，每页展示9个数据
        para[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
        [HMHttpTool get:url params:para success:^(id responseObj) {
            NSLog_JSON(@"订单列表%@",responseObj);
            if ([responseObj[@"status"]  isEqual: @1]  ) {

                NSMutableDictionary * newdic = [NSMutableDictionary dictionary];
                newdic =  responseObj[@"data"];

                for (NSDictionary  * dic in newdic) {
                    VLX_system_Order_Model * model = [VLX_system_Order_Model infoListWithDict:dic];
//                    NSLog(@"%@",model.msgid);//4168
                    [tabArray addObject:model];
                    
                    [orderIDArray addObject:model.orderid];//存订单id
                    [order_idAry addObject:model.orderid];

                }
                
                [_tableVW2.mj_header endRefreshing];
                [_tableVW2.mj_footer endRefreshing];
                [_tableVW2 reloadData];
            }
            else if([responseObj[@"data"] isKindOfClass:[NSNull class]] ){
                [SVProgressHUD showInfoWithStatus:@"您还没有订单消息"];
            }

        } failure:^(NSError *error) {
            NSLog_JSON(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
            [_tableVW2.mj_header endRefreshing];
        }];

}
-(void)changeMessageStatusWithMsgid:(NSString *)msgid//
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];

    dic[@"MsgId"]=[ZYYCustomTool checkNullWithNSString:msgid];//地区id（这个可以不传）
    NSString * url=[NSString stringWithFormat:@"%@/sysMsg/readSysMsgById.json",ftpPath];

    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        //        NSLog(@"%@",requestDic.mj_JSONString);
        [SVProgressHUD dismiss];



        if ([requestDic[@"status"] integerValue]==1) {


        }else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }

    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];

    }];
}

@end
