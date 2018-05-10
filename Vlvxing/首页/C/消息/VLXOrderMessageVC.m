//
//  VLXOrderMessageVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXOrderMessageVC.h"
#import "VLXMessageCenterCell.h"
#import "VLXMessageModel.h"
#import "VLXMyOrderDetailVC.h"

#import "VLX_myOrderDetailVC_new.h"//机票详情

@interface VLXOrderMessageVC ()<UITableViewDelegate,UITableViewDataSource,TitleButtonNoDataViewDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; //
@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
@property (nonatomic,strong)VLXMessageModel *messageModel;
@property (nonatomic,strong)NSNumber * typeNu;// =[[NSNumber alloc]init];

@end

@implementation VLXOrderMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    _currentPage=1;
    _typeNu =[[NSNumber alloc]init];
    _dataArr=[NSMutableArray array];
    //
    [self createUI];
    [self loadData];

}
-(void)createUI
{
    [self setNav];
    [self.view addSubview:self.tableview];
}
#pragma mark---数据
-(void)loadData
{
    [self refreshData];
}
#pragma mark--刷新
-(void)refreshData
{
    self.currentPage=1;
    [self getMessageData:1];
}
#pragma mark--加载
-(void)reloadMoreData
{
    self.currentPage++;
    [self getMessageData:2];
}


#pragma mark
-(void)getMessageData:(int)type//消息列表
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"token"]=[NSString getDefaultToken];
    dic[@"msgType"]=@"2";//消息类型  1：系统消息，2：通知消息
    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前所在页，每页展示9个数据
    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
    NSString * url=[NSString stringWithFormat:@"%@/sysMsg/auth/getsysmsglist.json",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog_JSON(@"列表👌:%@",requestDic.mj_JSONString);
        _messageModel=[[VLXMessageModel alloc] initWithDictionary:requestDic error:nil];
        if (_messageModel.status.integerValue == 1) {
            if (type == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:_messageModel.data];
            if(self.dataArr.count==0)
            {
                if(!_nodateView)
                {
                    _nodateView=[[TitleButtonNoDataView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kScreenHeight-64)];
                    _nodateView.backgroundColor=[UIColor whiteColor];
                    _nodateView.delegate=self;
                    _nodateView.titleText=@"暂无数据";
                    //                    [self.tableView addSubview:_nodateView];
                    _tableview.tableFooterView=_nodateView;
                    _nodateView.noDataButtonIsHidden=NO;
                    //                    _nodateView.nobtnTitle=@"立即设置";
                }
                [self.tableview reloadData];
            }
            else
            {
                if(_nodateView)
                {
                    [_nodateView removeFromSuperview];
                    _nodateView=nil;
                    _tableview.tableFooterView=nil;
                }
                [self.tableview reloadData];
            }
            
            [self.tableview.mj_header endRefreshing];
            [self.tableview.mj_footer endRefreshing];
        }else {
            
            [SVProgressHUD showErrorWithStatus:msg];
            [self.tableview.mj_header endRefreshing];
            [self.tableview.mj_footer endRefreshing];
            [self.tableview reloadData];
            
        }
        
    } failure:^(NSString *errorInfo) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark
#pragma mark
- (void)setNav{

    self.title = @"订单";
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
#pragma mark---no data delegate
-(void)titleButtonNoDataView:(TitleButtonNoDataView *)view didClickButton:(UIButton *)button
{
    NSLog(@"titleButtonNoDataView");
    [self refreshData];
}
#pragma mark
#pragma mark代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
//    return 1;
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
////    return _dataArr.count;
//}
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
    VLXMessageDataModel *model=_dataArr[indexPath.row];
    CGFloat height = [model.msgcontent sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth-83, MAXFLOAT)].height;
    if (height == 0) {
        return 76-14+height+15;
    }
    return 76-14+height;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    VLXMessageCenterCell * cell=[VLXMessageCenterCell cellWithTableView:tableView];
    if (_dataArr&&_dataArr.count>indexPath.row) {
        VLXMessageDataModel *model=_dataArr[indexPath.row];
        cell.topleftlabel.text=@"订单通知";
        cell.rightlabel.text=[[ZYYCustomTool checkNullWithNSString:model.msgtime] RwnTimeExchange];
        
        cell.leftimagmeview.image=[UIImage imageNamed:@"luguhu2"];
        cell.bottomLabel.text=[ZYYCustomTool checkNullWithNSString:model.msgcontent];
    }
    cell.pointview.hidden=YES;

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击了修改消息阅读状态


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_SERIAL, 0), ^{
        if (_dataArr&&_dataArr.count>indexPath.row) {
            VLXMessageDataModel *dataModel=_dataArr[indexPath.row];
            [self changeMessageStatusWithMsgid:[NSString stringWithFormat:@"%@",dataModel.msgid]];
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{//主线程
            VLXMyOrderDetailVC *detailVC=[[VLXMyOrderDetailVC alloc] init];
            VLX_myOrderDetailVC_new * jipiaodetaidVC = [[VLX_myOrderDetailVC_new alloc]init];
//            typeNu=0;
            if (_dataArr&&_dataArr.count>indexPath.row) {
                VLXMessageDataModel *dataModel=_dataArr[indexPath.row];
                detailVC.orderID=[NSString stringWithFormat:@"%@",dataModel.orderid];
                jipiaodetaidVC.orderid = [NSString stringWithFormat:@"%@",dataModel.orderid];

                NSLog(@"detailVC.orderID:%@", detailVC.orderID);
                NSLog(@"type:%@",dataModel.type);
                NSLog(@"type:%@",dataModel.type);

                _typeNu = dataModel.type;
            }

            NSLog(@"type:::%@",_typeNu);
            if([_typeNu isEqual:@0]){//路线
            [self.navigationController pushViewController:detailVC animated:YES];
            }
            else if ([_typeNu isEqual:@1]){//

            }
            else if ([_typeNu isEqual:@2]){//

            }
            else if ([_typeNu isEqual:@3]){//机票
                jipiaodetaidVC.typeNum = _typeNu;
            [self.navigationController pushViewController:jipiaodetaidVC animated:YES];
            }

        });
    });

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //方法实现后，默认实现手势滑动删除的方法
    
    if (editingStyle!=UITableViewCellEditingStyleDelete) {
        // 删除事件
        
        
        
    }
}

#pragma mark 选择编辑的样式

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;//手势滑动删除
    
}


#pragma mark 在滑动手势删除某一行的时候，显示出更多的按钮

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        NSString *urlStr = [NSString stringWithFormat:@"%@/sysMsg/deleteSysMsgInfo.json",ftpPath];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        VLXMessageDataModel *dataModel=_dataArr[indexPath.row];
        dic[@"msgId"] = [NSString stringWithFormat:@"%@",dataModel.msgid];
        [SPHttpWithYYCache postRequestUrlStr:urlStr withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
            if ([requestDic[@"status"] intValue] == 1) {
                // 成功
                // 1. 更新数据
                
                [_dataArr removeObjectAtIndex:indexPath.row];
                
                // 2. 更新UI
//                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.row] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } failure:^(NSString *errorInfo) {
            [SVProgressHUD showErrorWithStatus:errorInfo];
        }];
        
    }];
    return @[deleteRowAction];
    
}


-(void)changeMessageStatusWithMsgid:(NSString *)msgid//V头条数据
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
#pragma mark---事件
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 懒加载
-(UITableView * )tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //刷新
        self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    }


    return _tableview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
