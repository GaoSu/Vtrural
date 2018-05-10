//
//  VLXSystemMessageVC.m
//  Vlvxing
//
//  Created by Michael on 17/5/25.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLXSystemMessageVC.h"
#import "VLXMessageCenterCell.h"
#import "VLXShopHomepageVC.h"//店铺主页
#import "VLXMessageModel.h"

#import "VLXRouteDetailVC.h"//旅游线路详情
#import "VLXWebViewVC.h"//url
#import "VLX_TicketViewController.h"//机票


@interface VLXSystemMessageVC ()<UITableViewDelegate,UITableViewDataSource,TitleButtonNoDataViewDelegate>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,assign)int currentPage;//当前页
@property(nonatomic,strong) NSMutableArray *dataArr; //
@property(nonatomic,strong) NSMutableArray *httpArray; //

@property (nonatomic,strong)TitleButtonNoDataView *nodateView;
@property (nonatomic,strong)VLXMessageModel *messageModel;
@end

@implementation VLXSystemMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    _currentPage=1;
    _dataArr=[NSMutableArray array];
    _httpArray= [NSMutableArray array];
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
{//youm
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"token"]=[NSString getDefaultToken];//登录时获取的
    dic[@"msgType"]=@"1";//消息类型  1：系统消息，2：通知消息
    dic[@"currentPage"]=[NSString stringWithFormat:@"%d",_currentPage];//当前所在页，每页展示9个数据
    dic[@"pageSize"]=[NSString stringWithFormat:@"%d",pageSize];//页面数据
    NSString * url=[NSString stringWithFormat:@"%@/sysMsg/auth/getsysmsglist.json",ftpPath];
    NSLog(@"%@",dic);
    [SPHttpWithYYCache postRequestUrlStr:url withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
        [SVProgressHUD dismiss];
                NSLog_JSON(@"xt通知列表数据:%@",requestDic.mj_JSONString);
        _messageModel=[[VLXMessageModel alloc] initWithDictionary:requestDic error:nil];
        if (_messageModel.status.integerValue == 1) {
            if (type == 1) {
                [self.dataArr removeAllObjects];
                [_httpArray removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:_messageModel.data];
//            [self.httpArray addObjectsFromArray:]
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
- (void)setNav{

    self.title = @"系统公告";//标题
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



//    //右边
//    CGFloat imageWidth=22;
//    UILabel * clearLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, imageWidth*3, imageWidth*2)];
//    clearLb.text = @" 清除全部 ";
//    clearLb.textColor =[UIColor lightGrayColor];
//
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:clearLb];
//    //添加手势
//    clearLb.userInteractionEnabled=YES;
//    UITapGestureRecognizer *rightTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightNavItemClicked)];
//    [clearLb addGestureRecognizer:rightTap];


}
-(void)rightNavItemClicked{
    NSLog(@"清除了全部消息提示");
}
#pragma mark
#pragma mark---no data delegate
-(void)titleButtonNoDataView:(TitleButtonNoDataView *)view didClickButton:(UIButton *)button
{
    NSLog(@"titleButtonNoDataView");
    [self refreshData];
}
#pragma mark
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
    return _dataArr.count;
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
    VLXMessageDataModel *model=_dataArr[indexPath.section];
    CGFloat height = [model.msgcontent sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth-83, MAXFLOAT)].height;
    if (height == 0) {
        return 76-14+height+15;
    }
    return 76-14+height;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    VLXMessageCenterCell * cell=[VLXMessageCenterCell cellWithTableView:tableView];
    if (_dataArr&&_dataArr.count>indexPath.section) {
        VLXMessageDataModel *model=_dataArr[indexPath.section];
        cell.topleftlabel.text=[ZYYCustomTool checkNullWithNSString:model.titile];
        cell.rightlabel.text=[[ZYYCustomTool checkNullWithNSString:model.msgtime] RwnTimeExchange];
        
        cell.leftimagmeview.image=[UIImage imageNamed:@"luguhu2"];
        cell.bottomLabel.text=[ZYYCustomTool checkNullWithNSString:model.msgcontent];
        NSLog(@"%@",model.msgstatus);
        if([model.msgstatus isEqual:@0]){
            cell.pointview.hidden=YES;
        }else{
            cell.pointview.hidden=NO;
        }
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark---事件
-(void)tapLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLXRouteDetailVC * vc= [[VLXRouteDetailVC alloc]init];

    VLXWebViewVC *webView1 = [[VLXWebViewVC alloc]init];

    UINavigationController *nav = self.cyl_tabBarController.selectedViewController;

//    VLXMessageCenterCell * cell = [[VLXMessageCenterCell alloc]init];
//    cell.pointview.hidden = YES;
//    VLXMessageDataModel * model33 = _dataArr[indexPath.row];//找到对应的行号
//    model33.msgstatus = @1;
//    NSIndexPath *indexP=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
//    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexP,nil] withRowAnimation:UITableViewRowAnimationNone];


    NSString * urlstringgg=[[NSString alloc]init];
    NSNumber *intNumber = [NSNumber numberWithInt:0];
    NSString * class_NAME = [[NSString alloc]init];
    if (_dataArr&&_dataArr.count>indexPath.row) {
        VLXMessageDataModel *dataModel=_dataArr[indexPath.section];
        [self changeMessageStatusWithMsgid:[NSString stringWithFormat:@"%@",dataModel.msgid]];

        NSLog(@"xx:%@",dataModel.msgid);
        NSLog(@"xxx:%@", dataModel.msgurl);
        urlstringgg = dataModel.msgurl;
        intNumber = dataModel.type;
        class_NAME = dataModel.iosclassname;
        vc.biaoshi = @"2";
        vc.url=urlstringgg;
        webView1.urlStr = urlstringgg;
    }

    if ([intNumber isEqual:@0]) {//不跳转
        NSLog(@"00000信用卡");
    }
    else if ([intNumber isEqual:@1]){//url
        NSLog(@"11111");
            if (urlstringgg==nil) {
                NSLog(@"url为空,不跳转");
            }else{
                [self.navigationController  pushViewController:webView1 animated:YES];
            }
    }
    else if ([intNumber isEqual:@2]){//类
        NSLog(@"22222");

        NSString * classNamestr = class_NAME;//jsonObject[@"data"][@"data"];
        id myObj = [[NSClassFromString(classNamestr) alloc] init];//找到类名,然后跳转
        [nav pushViewController:myObj animated:YES];
    }
    else if ([intNumber isEqual:@3]){//线路id
        NSLog(@"33333");
        
    }


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
        VLXMessageDataModel *dataModel=_dataArr[indexPath.section];
        dic[@"msgId"] = [NSString stringWithFormat:@"%@",dataModel.msgid];
        [SPHttpWithYYCache postRequestUrlStr:urlStr withDic:dic success:^(NSDictionary *requestDic, NSString *msg) {
            if ([requestDic[@"status"] intValue] == 1) {
                // 成功
                // 1. 更新数据
                
                [_dataArr removeObjectAtIndex:indexPath.section];
                
                // 2. 更新UI
                
//                [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
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



#pragma mark 懒加载
-(UITableView * )tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
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
