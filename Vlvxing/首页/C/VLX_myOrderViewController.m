//
//  VLX_myOrderViewController.m
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_myOrderViewController.h"
#import "VLX_myOrderTableViewCell.h"
#import "VLX_myOrderModel.h"

#import "VLX_orderDetailsViewController.h"//订单详情
#import "VLX_zhifubao_OR_weixin_VC.h"//未支付订单,直接支付
#import "VLX_guoqibookingVC.h"//过期的订单,或者已退款订单,就是看看,没有操作.也是
#import "VLX_myOrderDetailVC_new.h"

#import "HMHttpTool.h"//自定义的

#import "VLX_TicketViewController.h"


@interface VLX_myOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray * tabArray;//列表数据
    NSMutableArray * orderIDArray;//订单id数组
    NSMutableArray * chengkexinxiAry0;//乘客信息 用于下下下下下个界面用户id
    NSMutableArray * order_noAry;//订单号
    NSMutableArray * order_idAry;//订单id
    NSMutableArray * phoneAry;//订单id
    
    NSString * jiadePassengerid;//假的乘客id,本来是个数组,
    NSMutableArray * passngeridAry0;
    NSMutableArray * passngeridAry1;


}

@property (nonatomic, strong)UITableView * tableVW2;

@end

@implementation VLX_myOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的机票";
    
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
    chengkexinxiAry0 = [NSMutableArray array];
    order_noAry = [NSMutableArray array];
    order_idAry = [NSMutableArray array];
    phoneAry = [NSMutableArray array];
    
    passngeridAry0 = [NSMutableArray array];
    passngeridAry1 = [NSMutableArray array];

    
    NSLog(@"订单id:%@",_dingdanID);
    
    
    [self lodaData_Order];
    
    [self makeUI];
    
    
    
}
-(void)tapLeftButton3
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeUI{
    
    _tableVW2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    
    _tableVW2 .delegate = self;
    _tableVW2. dataSource = self;
    //去除多余分割线
    _tableVW2.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //刷新
    _tableVW2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//    _tableVW2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    
    
    [self.view addSubview:_tableVW2];
    
}
-(void)refreshData{
    
    
    [tabArray removeAllObjects];//清空数据源
    [self lodaData_Order];
//    [_tableVW2 reloadData];
}

#pragma delegate
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
        
        VLX_myOrderTableViewCell *cell = [_tableVW2 dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[VLX_myOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
            if (tabArray.count > 0) {
                [cell FillWithModel:tabArray[indexPath.row]];

            }
        return cell;
    }

    return nil;
    
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
    }];//此处是iOS8.0以后苹果最新推出的api，UITableViewRowAction，Style是划出的标签颜色等状态的定义，这里也可自行定义
    
    
    deleteRoWAction.backgroundColor = [UIColor colorWithRed:243/255.0 green:77/255.0 blue:66/255.0 alpha:1];//主色
    
    
    
    return @[deleteRoWAction];
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VLX_myOrderTableViewCell * cell = [_tableVW2 cellForRowAtIndexPath:indexPath];



    if ([cell.typelb.text isEqualToString:@"已支付"]) {
    VLX_myOrderDetailVC_new * vc = [[VLX_myOrderDetailVC_new alloc]init];
    vc.chengkexinxiAry = [[NSMutableArray alloc]init];
    vc.chengkexinxiAry = chengkexinxiAry0[indexPath.row];

//    NSLog(@"%@",order_noAry[indexPath.row]);

    vc.Phone_NoStr = phoneAry[indexPath.row];
    vc.flyDatesStr =cell.timeLb.text;
    vc.flyTimeStr = cell.flyLb.text;
    vc.downTimeStr = cell.downLb.text;//降落时间
    vc.zongshichang = cell.zongshichangLb.text;
    vc.flyCityStr =cell.area1Lb.text;////起飞城市
    vc.downCityStr =cell.area2Lb.text;
    vc.flyPortStr = cell.deptairportcity.text;
    vc.downportStr =cell.arriairportcity.text;
    vc.hangbanNoStr =cell.hangbanNoLb.text;
    vc.jiageStr = cell.jiageLb.text;
    vc.orderno =cell.ordernoLb.text;
    vc.orderid = cell.orderidLb.text;
    vc.statusdescStr = cell.typelb.text;

    vc.jiadePassengerid = jiadePassengerid;
    
    if (passngeridAry1.count > 0) {
        [passngeridAry1 removeAllObjects];
    }
    for (NSDictionary * dic7 in passngeridAry0[indexPath.row]) {
        [passngeridAry1 addObject:dic7[@"passengerid"]];
//        NSLog(@"%ld,NO:%@",passngeridAry1.count, passngeridAry1.lastObject);
    }
    vc.passengeridArray = [NSMutableArray array];
    vc.passengeridArray = passngeridAry1;//整个数组传过去
    // 选中不变色
    [_tableVW2 deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cell.typelb.text isEqualToString:@"未支付"]){
        VLX_zhifubao_OR_weixin_VC * vc= [[VLX_zhifubao_OR_weixin_VC alloc]init];
        
        vc.jiageStr = cell.jiageLb.text;
        vc.orderno =cell.ordernoLb.text;
        vc.orderid = cell.orderidLb.text;
        
        vc.Phone_NoStr = phoneAry[indexPath.row];
        vc.flyDatesStr =cell.timeLb.text;
        vc.flyTimeStr = cell.flyLb.text;
        vc.downTimeStr = cell.downLb.text;//降落时间
        vc.zongshichang = cell.zongshichangLb.text;
        vc.flyCityStr =cell.area1Lb.text;////起飞城市
        vc.downCityStr =cell.area2Lb.text;
        vc.flyPortStr = cell.deptairportcity.text;
        vc.downportStr =cell.arriairportcity.text;
        vc.hangbanNoStr =cell.hangbanNoLb.text;
        vc.statusdescStr = cell.typelb.text;
        
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([cell.typelb.text isEqualToString:@"退票"] || [cell.typelb.text isEqualToString:@"已退票"]) {//
        VLX_guoqibookingVC * vc =[[VLX_guoqibookingVC alloc]init];
        vc.jiageStr = cell.jiageLb.text;
        vc.orderno =cell.ordernoLb.text;
        vc.orderid = cell.orderidLb.text;
        
        vc.Phone_NoStr = phoneAry[indexPath.row];
        vc.flyDatesStr =cell.timeLb.text;
        vc.flyTimeStr = cell.flyLb.text;
        vc.downTimeStr = cell.downLb.text;//降落时间
        vc.zongshichang = cell.zongshichangLb.text;
        vc.flyCityStr =cell.area1Lb.text;////起飞城市
        vc.downCityStr =cell.area2Lb.text;
        vc.flyPortStr = cell.deptairportcity.text;
        vc.downportStr =cell.arriairportcity.text;
        vc.hangbanNoStr =cell.hangbanNoLb.text;
        vc.statusdescStr = cell.typelb.text;
        [self.navigationController pushViewController:vc animated:YES];

    }



}



-(void)lodaData_Order
{
    if ([NSString getDefaultToken]) {
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"selectFlyOrderByUserId"];
    NSMutableDictionary * para = [NSMutableDictionary dictionary];

        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
        NSString *userID = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
    
        para[@"userid"]=userID;//[NSString getDefaultUser];
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"订单列表%@",responseObj);
        if ([responseObj[@"status"]  isEqual: @1]  ) {
            
            NSMutableDictionary * newdic = [NSMutableDictionary dictionary];
            newdic =  responseObj[@"data"];

            for (NSDictionary  * dic in newdic) {
                VLX_myOrderModel * model = [VLX_myOrderModel infoListWithDict:dic];
                [tabArray addObject:model];
                [orderIDArray addObject:model.orderid];//存订单id
                [chengkexinxiAry0 addObject:model.passengers];
                [order_idAry addObject:model.orderid];
                [order_noAry addObject:model.orderno];
                [phoneAry addObject:model.phone];
                NSLog(@"-------%ld",chengkexinxiAry0.count);

            }

            jiadePassengerid = chengkexinxiAry0[0][0][@"passengerid"];

            for (NSDictionary * dic6 in chengkexinxiAry0) {
                NSLog(@"dic>:%@",dic6);
                [passngeridAry0 addObject:dic6];//将所有乘客信息存入数组
            }
            [_tableVW2.mj_header endRefreshing];
            [_tableVW2.mj_footer endRefreshing];
            [_tableVW2 reloadData];
        }
        else if([responseObj[@"data"] isKindOfClass:[NSNull class]] ){
                        [SVProgressHUD showInfoWithStatus:@"您还没有机票订单"];

            [_tableVW2.mj_header endRefreshing];
//            [_tableVW2.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        NSLog_JSON(@"%@",error);
//        [self.tableVW2 addEmptyViewWithImageName:@"" title:@"未能连接到服务器"];
        [SVProgressHUD showErrorWithStatus:@"请求超时"];
        [_tableVW2.mj_header endRefreshing];
    }];
    }if (![NSString getDefaultToken]) {
        [SVProgressHUD showInfoWithStatus:@"您未登录,请您登录"];
    }
    
}



@end
