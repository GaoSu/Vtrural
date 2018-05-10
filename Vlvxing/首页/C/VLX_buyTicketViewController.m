//
//  VLX_buyTicketViewController.m
//  Vlvxing
//
//  Created by grm on 2017/10/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_buyTicketViewController.h"

#import "VLX_buyTicketTableViewCell.h"
#import "VLX_buyTicketTableViewCell_2.h"
#import "VLX_buyTicketTableViewCell_3.h"
#import "VLX_buyTicketTableViewCell_4.h"
#import "VLX_buyTicketTableViewCell_5.h"
#import "VLX_buyTicketTableViewCell_6.h"
#import "VLX_buyTicketTableViewCell_7.h"
#import "VLX_buyTicketTableViewCell_8.h"

#import "VLX_baoxiaoTableViewCell_0.h"//报销
#import "VLX_baoxiaoTableViewCell.h"
#import "VLX_myOrderViewController.h"

#import "VLX__chengkexuzhiVC.h"

#import "VLXInputOrderModel.h"//正则表达式
#import "IQKeyboardManager.h"
#import "HMHttpTool.h"//
@interface VLX_buyTicketViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,xieyi_xieyi>

{
    UILabel * navLb11;//地点1
    UIImageView * jiantouVw11;//箭头
    UILabel * navLb22;//地点2
    
    NSInteger indexx;//增加乘客
    NSMutableArray * dicArray;
    
    NSInteger indxrow;//失去第一响应
    
    UIView * _bigVw1;//弹窗背景半透明
    UIView * _bigVw2;
    UIView * _popView1;//弹窗
    
    NSString * _jiageStr;//票价

    UIButton * buyBt;
    
    //一堆假数据
    NSString * otherStr;//其他费用
    NSString * jinshengStr;//剩余票
    NSString * baoxianStr;//航意险
    
    NSInteger  isSelect;//标记用于是否选中
    NSInteger _pay_ZhifubaoOrWeixin;//支付宝0,还是微信1
    
    NSArray * titileAry;//支付宝/微信.文字
    NSArray * imgAry;//支付宝/微信.图标
    
    
    NSArray * baoxiaoTitleAry;//报销
    
    //参数部分
    NSString * nameString;//乘客姓名长串, 以,隔开,
    NSString * ID_CardString;//乘客身份证号长串, 以,隔开,
    
    
//    UIView * popView2;
    NSInteger aaaa;

    
    
}

@property (nonatomic,strong)UITableView * tabvw;

@property (nonatomic,strong)UILabel * jiageLb;

@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong,nonatomic)NSMutableArray * name_Ary;//乘客名字数组
@property (strong,nonatomic)NSMutableArray * ID_NoAry;//身份证号码数组

@property (strong,nonatomic)NSMutableArray * name_Ary_dismiss;//乘客名字数组,消失时候添加的数组
@property (strong,nonatomic)NSMutableArray * ID_NoAry_dismiss;//身份证号码数组,消失时候添加的数组

@property (strong, nonatomic) NSMutableArray *deleteArr;

@property (nonatomic,strong)VLXInputOrderModel *orderModel_1;//正则

@property (nonatomic,strong)    UITextField * texdFd1;
@property (nonatomic,strong)    UITextField * texdFd2;

@property (nonatomic,strong)    UITextField * texdFd3;//电话

@property (nonatomic,strong)    UITextField * texdFd4;//报销用
@property (nonatomic,strong)    UITextField * texdFd5;//报销用
@property (nonatomic,strong)    UITextField * texdFd6;//报销用


@property (nonatomic,strong)  NSString * baoxiaoName;//报销用
@property (nonatomic,strong)  NSString * baoxiaoPhone;//报销用
@property (nonatomic,strong)  NSString * baoxiaoAddress;//报销用


@property (nonatomic,assign)float jiage;//价格
@property (nonatomic,strong)NSString * orderid;//订单id
@property (nonatomic,strong)NSString * orderNO;//订单号




@property (nonatomic,strong) UIButton * chengkexuzhiBt;

@property(nonatomic,strong)NSArray *cellArray;//展示用来下啦的踩但
@property (assign, nonatomic) NSInteger openedSection;//记录已经打开得section的index，便于在后面打开别的section时关闭之前打开的section下拉菜单。


@end

@implementation VLX_buyTicketViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    
    [self addNotification];//支付结果通知

    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
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
#pragma mark 微信. 结果通知
- (void)getWXPayResult:(NSNotification *)sender
{
    [SVProgressHUD dismiss];
    NSString *result = sender.object;
    if ([result isEqualToString:@"success"])
    {
         NSLog(@"郭荣明_支付测试006成功");
        [SVProgressHUD showSuccessWithStatus:@"支付成功!"];
        sleep(3.0f);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"grmzfbOK" object:nil];

    }else
    {
         NSLog(@"郭荣明_支付测试006失败");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"grmzfb_buok" object:nil];
         sleep(3.0f);
        [SVProgressHUD showErrorWithStatus:@"支付失败，请重试"];
    }
}
#pragma mark 支付宝. 结果通知
- (void)getAliPayResult:(NSNotification *)sender
{
    [SVProgressHUD dismiss];
    NSDictionary *resultDic = sender.userInfo;
    //MyLog(@"AlipaySDK reslut = %@",resultDic);
    if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000)
    {
         NSLog(@"郭荣明_支付测试005成功");
        sleep(3.0f);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"grmzfbOK" object:nil];
        
        [SVProgressHUD showSuccessWithStatus:@"支付成功!"];
        
        
    }else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             NSLog(@"郭荣明_支付测试失败005");
            sleep(3.0f);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"grmzfb_buok" object:nil];
            [SVProgressHUD showErrorWithStatus:@"支付失败，请重试"];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton5) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton5)];

    
    indexx =1;//先赋值，不然不好控制
    isSelect = 1;//默认不选中保险，修改默认选中
    _pay_ZhifubaoOrWeixin = 0;//默认支付宝
    
    
    
    //票价
    _jiageStr = [_jiageStr_0 stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    jinshengStr= @"8";//剩余票
    
    titileAry = [NSArray array];
    titileAry = @[@"支付宝",@"微信"];
    imgAry = [NSArray array];
    imgAry =    @[@"alipay",@"WeChat-pay"];
    baoxiaoTitleAry = [NSArray array];
    
    baoxiaoTitleAry = @[@"报销",@"快递费",@"发票抬头",@"电话",@"收件地址"];
    aaaa=1;//最开始默认一行
    
    _name_Ary = [NSMutableArray array];//只存名字
    _ID_NoAry = [NSMutableArray array];//只存身份证
    
    _name_Ary_dismiss = [NSMutableArray array];
    _ID_NoAry_dismiss = [NSMutableArray array];
    
    _orderModel_1=[[VLXInputOrderModel alloc] init];
    
    _texdFd1 = [[UITextField alloc]init];
    _texdFd2 = [[UITextField alloc]init];
    _texdFd3 = [[UITextField alloc]init];
    
    _texdFd4 = [[UITextField alloc]init];
    _texdFd5 = [[UITextField alloc]init];
    _texdFd6 = [[UITextField alloc]init];
    
    dicArray = [NSMutableArray array];
    
    nameString = [[NSString alloc]init];
    ID_CardString = [[NSString alloc]init];
    
    _cellArray = [NSMutableArray array];
    _cellArray = @[@"1",@"2",@"3"];//下拉显示的cell的数量
    
    NSLog(@"%@",_jijianranyoustr);
    
    
    self.view.backgroundColor = rgba(230, 230, 230, 1);
    [self makeNav3];
  
    [self makeMineUI];

    
    _chengkexuzhiBt = [[UIButton alloc]initWithFrame:CGRectMake(21, 17, 21, 21)];
    [_chengkexuzhiBt setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [_chengkexuzhiBt setImage:[UIImage imageNamed:@"选择后"] forState:UIControlStateSelected];
    [_chengkexuzhiBt addTarget:self action:@selector(tongyi)forControlEvents:UIControlEventTouchUpInside];
    _chengkexuzhiBt.selected = YES;
    NSLog_JSON(@"预定结果生单用bookingResult:%@",_bookingResult);
    
    [self makeBt];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide_1:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewshenmeguiVwOK) name:@"grmzfbOK" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewshenmeguiVwFail) name:@"grmzfb_buok" object:nil];

    
}
//跳转我的订单界面,已完成支付
-(void)pushViewshenmeguiVwOK{
    
    
//    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"aliPay/flyforderstatus"];
//    NSMutableDictionary * para = [NSMutableDictionary dictionary];
//    if (_orderid == nil) {
//        NSLog(@"没有订单");
//    }else{
//        
//        para[@"orderid"] = _orderid;
//        NSLog(@"dingdanID:%@",_orderid);
//        [HMHttpTool get:url params:para success:^(id responseObj) {
//        NSLog_JSON(@"%@",responseObj);
    
        VLX_myOrderViewController * vc = [[VLX_myOrderViewController alloc]init];
        vc.dingdanID = _orderid;
        [self.navigationController pushViewController:vc animated:YES];
        
//        
//    } failure:^(NSError *error) {
//        NSLog_JSON(@"%@",error);
//    }];
//    
//    }
    
    
}
-(void)pushViewshenmeguiVwFail{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
}

-(void)tapLeftButton5
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)makeNav3
{
    navLb11 = [[UILabel alloc]initWithFrame:CGRectMake(44*(ScreenWidth/375), 10, 110*(ScreenWidth/375), 22)];
    navLb11.text = _navStr11;
    navLb11.textAlignment = NSTextAlignmentRight;
    navLb11.font = [UIFont systemFontOfSize:20];
    
    jiantouVw11 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 42/2, 15, 42, 15)];
    jiantouVw11.image = [UIImage imageNamed:@"目的地"];
    
    navLb22 = [[UILabel alloc]initWithFrame:CGRectMake(220*(ScreenWidth/375), 10, 93, 22)];
    navLb22.text = _NavStr22;
    navLb22.textAlignment = NSTextAlignmentLeft;
    navLb22.font = [UIFont systemFontOfSize:20];
    
    
    [self.navigationController.navigationBar addSubview:navLb11];
    [self.navigationController.navigationBar addSubview:jiantouVw11];
    [self.navigationController.navigationBar addSubview:navLb22];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [navLb11 removeFromSuperview];
    [jiantouVw11 removeFromSuperview];
    [navLb22 removeFromSuperview];
    
}
-(void)makeMineUI
{
    _tabvw =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-50-64) style:UITableViewStyleGrouped];
    _tabvw.delegate = self;
    _tabvw.dataSource = self;
//    _tabvw.editing = YES;//ke bian ji

    
    
    
    
    [self .view addSubview:_tabvw];
    
}
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
    {
        return  2;
    }
    else if(section == 1)
    {
        return indexx;//
    }
    else if(section == 2)
    {
        return 1;
    }
    else if(section == 3)
    {
        return aaaa;
    }
    else if(section == 4)
    {
        return 2;
    }
    return 0;
        
}
//高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 60;
    }
    else if(indexPath.section == 1)
    {
        return 110;
    }
    else if(indexPath.section == 2)
    {
        return  48;
    }
    else if(indexPath.section == 3)
    {
        return  48;
    }
    else if(indexPath.section == 4)
    {
        return 53;
    }



    return 0;
    
}

//头高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 1) {
//        return 45;
//    }
//    else if
        if(section == 2){
        return 5;
    }
//    else if (section == 3){
//        return ;
//    }
    else if (section == 4){
        return 45;
    }
        
        return 0.001;
}
//尾高
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 52;
    }
    else if (section == 4)
    {
        return 55;
    }
    else return 5;
}

#pragma mark 自定义的组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(_tabvw == tableView)
    {
            if(section == 1){
                UIView * headerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , 44)];
                
                headerVw.backgroundColor = [UIColor whiteColor];
                
                UILabel  * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(23, 14, 35, 15)];
                lb1.text = @"旅客";
                
                
                UILabel  * lb2 = [[UILabel alloc]initWithFrame:CGRectMake(75, 14, 105, 15)];
                lb2.text = @"仅剩8张成人票";//[NSString stringWithFormat:@"仅剩%@张成人票",str];
                lb2.font =[ UIFont systemFontOfSize:14];
                lb2.textColor = rgba(225, 75, 29, 1);
                
                
                UILabel  * lb3 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-85, 14, 65, 15)];
                lb3.text = @"旅客信息";
                lb3.font =[ UIFont systemFontOfSize:14];
                lb3.textColor = rgba(232, 133, 98, 1);
                
                [headerVw addSubview:lb1];//(75, 14, 107, 15)
                [headerVw addSubview:lb2];
                [headerVw addSubview:lb3];
//                return headerVw;
                
                return nil;
            }
            else if (section == 4){
                UIView * headerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , 44)];
                
                headerVw.backgroundColor = [UIColor whiteColor];
                
                UILabel  * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(23, 14, 60, 15)];
                lb1.text = @"支付方式";
                lb1.textColor = [UIColor lightGrayColor];
                lb1.font = [UIFont systemFontOfSize:14];

                
                [headerVw addSubview:lb1];

                return headerVw;
            }
            
        else return nil;
    }
    else return nil;
    
}
#pragma mark 自定义的组尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(_tabvw == tableView)
    {
        if(section == 1){
            UIView * footerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , 52)];
            
            footerVw.backgroundColor = [UIColor whiteColor];
            
            UIButton  * addBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2- 118/2, 12, 118, 28)];
            addBt.backgroundColor = rgba(229, 125, 83, 1);
            [addBt setTitle:@"+新增乘客" forState:UIControlStateNormal];
            addBt.layer.cornerRadius = 5;
            [addBt addTarget:self action:@selector(PressAddBt) forControlEvents:UIControlEventTouchUpInside];
            

            [footerVw addSubview:addBt];
            return footerVw;
            
            
        }
        else if(section == 4){
            UIView * footerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , 52)];
            
            footerVw.backgroundColor = rgba(229, 229, 229, 1);
            
            
            UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(49, 22, 94, 14)];
            lb.text = @"我已阅读并同意";
            lb.font = [UIFont systemFontOfSize:13];
            
            UIButton * bt = [[UIButton alloc]initWithFrame:CGRectMake(138, 22, 354/2, 14)];
            [bt setTitle:@"《锂电池及危险品乘机须知》" forState:UIControlStateNormal];
            [bt setTitleColor:rgba(230, 126, 82, 1) forState:UIControlStateNormal];
            bt.font = [UIFont systemFontOfSize:13];
            [bt addTarget:self action:@selector(pressBt) forControlEvents:UIControlEventTouchUpInside];
            
            [footerVw addSubview:lb];
            [footerVw addSubview:bt];
            [footerVw addSubview:_chengkexuzhiBt];
            return footerVw;
            
            
            
        }

        
        else return nil;
    }

    
    return nil;
}
#pragma mark 乘客须知
-(void)pressBt
{
    VLX__chengkexuzhiVC * vc = [[VLX__chengkexuzhiVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 同意
-(void)tongyi
{
    _chengkexuzhiBt.selected = !_chengkexuzhiBt.selected;
    
    if (_chengkexuzhiBt.selected == YES) {
        buyBt.userInteractionEnabled = YES;
        buyBt.backgroundColor = rgba(230, 83, 35, 1);
        [buyBt addTarget:self action:@selector(pressBuyBt:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        buyBt.backgroundColor = [UIColor lightGrayColor];
        buyBt.userInteractionEnabled = NO;
    }
    
    
}
#pragma  添加乘客 正则式
-(void)PressAddBt{

        [NSString setName:_texdFd1.text];
        _orderModel_1.name = [ZYYCustomTool checkNullWithNSString:_texdFd1.text];
        [NSString setIdNum:_texdFd2.text];
        _orderModel_1.IDCard=[ZYYCustomTool checkNullWithNSString:_texdFd2.text];


    BOOL isFull=[_orderModel_1 checkIsFull_2];
    if (!isFull) {
        //[SVProgressHUD showErrorWithStatus:@"订单信息不正确，请重新输入"];
        return;//
    }else
    {
        NSLog(@"正确");
        
        [_name_Ary addObject:_texdFd1.text];//只存名字
        [_ID_NoAry addObject:_texdFd2.text];//只存身份证
        
//        nameString = [_name_Ary componentsJoinedByString:@","];
//        ID_CardString = [_ID_NoAry componentsJoinedByString:@","];
    }
    
    indexx +=1;
    [_tabvw reloadData];
//    int total;
//    if(isSelect == 1)//保险选中
//    {
//        total = [_jiageStr intValue]*indexx + [otherStr intValue] *indexx + [baoxianStr intValue]*indexx;
//    }
//    else if (isSelect == 0)
//    {
//        total = [_jiageStr intValue]*indexx + [otherStr intValue] *indexx;
//    }
    
    
//    _jiageLb.text = [NSString stringWithFormat:@"¥%d",total];
    
}
//当键退出
- (void)keyboardWillHide_1:(NSNotification *)notification
{

    NSLog(@"收起键盘了");

    
    [NSString setName:_texdFd1.text];
    _orderModel_1.name = [ZYYCustomTool checkNullWithNSString:_texdFd1.text];
    [NSString setIdNum:_texdFd2.text];
    _orderModel_1.IDCard=[ZYYCustomTool checkNullWithNSString:_texdFd2.text];
    
    
    BOOL isFull=[_orderModel_1 checkIsFull_2];
    if (!isFull) {
        //[SVProgressHUD showErrorWithStatus:@"订单信息不正确，请重新输入"];
        return;//
    }else
    {        
        [_name_Ary_dismiss addObject:_texdFd1.text];//只存名字
        [_ID_NoAry_dismiss addObject:_texdFd2.text];//只存身份证
        
        
        //过滤数组中重复的元素
        NSMutableArray * aryyyyyy1 = [NSMutableArray array];
        NSMutableArray * aryyyyyy2 = [NSMutableArray array];
        aryyyyyy1 = [_name_Ary_dismiss valueForKeyPath:@"@distinctUnionOfObjects.self"];
        aryyyyyy2 = [_ID_NoAry_dismiss valueForKeyPath:@"@distinctUnionOfObjects.self"];
        NSLog(@"%ld",_name_Ary_dismiss.count);
        
        int total;
        total = [_jiageStr intValue]*indexx + [_jijianranyoustr intValue] *indexx;
        NSLog(@"total::%d",total);
        _jiageLb.text = [NSString stringWithFormat:@"¥%d",total];

        nameString = [aryyyyyy1 componentsJoinedByString:@","];
        ID_CardString = [aryyyyyy2 componentsJoinedByString:@","];
    }
    

    
    
    [NSString setName:_texdFd4.text];
    _orderModel_1.name1 = [ZYYCustomTool checkNullWithNSString:_texdFd4.text];

    [NSString setPhoneNum:_texdFd5.text];
    _orderModel_1.phone1 = [ZYYCustomTool checkNullWithNSString:_texdFd5.text];
    
    [NSString setAddress:_texdFd6.text];
    _orderModel_1.address1 = [ZYYCustomTool checkNullWithNSString:_texdFd6.text];
    
    
    
    if (aaaa == 5) {
        BOOL isFull_1=[_orderModel_1 checkIsFull_4];
        if (!isFull_1) {
            //请重新输入
            return;//
        }else{
            _baoxiaoName = _texdFd4.text;
            _baoxiaoPhone = _texdFd5.text;
            _baoxiaoAddress = _texdFd6.text;
            int total;
            total = [_jiageStr intValue]*indexx + [_jijianranyoustr intValue] *indexx;
            _jiageLb.text = [NSString stringWithFormat:@"¥%d",total+20];//加上报销的20元费用

        }
        
        NSLog(@"%@~%@~%@",_baoxiaoName,_baoxiaoPhone,_baoxiaoAddress);
    }


    
    
}


#pragma mark 删除乘客
-(void)pressDeletBt:(UIButton *)sender{
    if (indexx == 1) {
        [SVProgressHUD showErrorWithStatus:@"至少需要一位乘客"];

    }

    else{
    NSIndexPath * indx = [NSIndexPath indexPathForRow:sender.tag inSection:1];//删除哪一行的行号
        NSLog(@"删除了第几行:%ld",indx.row);
//        NSLog(@"剩几:%ld,%ld",_ID_NoAry.count,_name_Ary.count);
        if (indx.row == _name_Ary_dismiss.count ) {
            NSLog(@"删除空白的");
        }
        else{//数据源个数不大于行数,确保能有数据可删除
            [_name_Ary_dismiss removeObjectAtIndex:indx.row];
            [_ID_NoAry_dismiss removeObjectAtIndex:indx.row];
            
            nameString = [_name_Ary_dismiss componentsJoinedByString:@","];
             NSLog(@"删除之后的:%@",nameString);

            ID_CardString = [_ID_NoAry_dismiss componentsJoinedByString:@","];
            NSLog(@"删除之后的:%@\n%@",nameString,ID_CardString);
            
            
        }
        indxrow = indx.row;

    indexx -=1;
        VLX_buyTicketTableViewCell_3 * cell= [_tabvw cellForRowAtIndexPath:indx];
        cell.nameTxfd.text = @"";
        cell.ID_CardTxfd.text = @"";
        [_tabvw deleteRowsAtIndexPaths:@[indx] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tabvw reloadData];
        NSLog(@"xxxxxx:%ld",indexx);
        
         int total;
//        if(isSelect == 1)
//        {
//            total = [_jiageStr intValue]*indexx + [otherStr intValue] *indexx + [baoxianStr intValue]*indexx;
//        }
//        else if (isSelect == 0)
//        {
            total = [_jiageStr intValue]*indexx + [_jijianranyoustr intValue] *indexx;
//        }
       
        
        _jiageLb.text = [NSString stringWithFormat:@"¥%d",total];
       
    }
    
    
}
#pragma mark 填充
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tabvw == tableView)
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {

                static NSString * id = @"cell";
                
                VLX_buyTicketTableViewCell *cell = [_tabvw dequeueReusableCellWithIdentifier:id];
                if (!cell) {
                    cell = [[VLX_buyTicketTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:id];
                }
                //    if (_dataArr_rili.count > 0) {
                ////        [cell FillWithModel:_dataArr[indexPath.row]];
                //
                //    }
                cell.timeLb.text = _timeStr;
                cell.xingqiLb.text = _xingqiStr;
                return cell;
            }
            else
            {
                
                VLX_buyTicketTableViewCell_2 * cell = [_tabvw dequeueReusableCellWithIdentifier:@"buyTicket2"];
                
                if (!cell) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = [[VLX_buyTicketTableViewCell_2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyTicket2"];
                    cell.ticket_jiageLb.text = [NSString stringWithFormat:@"%@%@",@"票价:",_jiageStr];
                    cell.other_jiageLb.text = [NSString stringWithFormat:@"%@%@",@"基建燃油:¥ ",_jijianranyoustr];
                }
                
                return cell;

            }
        }
        else if(indexPath.section == 1)
        {
            VLX_buyTicketTableViewCell_3 * cell = [_tabvw dequeueReusableCellWithIdentifier:@"buyTicket3"];
            
            if (!cell) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell = [[VLX_buyTicketTableViewCell_3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyTicket3"];



                
            }
            _texdFd1 = cell.nameTxfd;
            _texdFd2 = cell.ID_CardTxfd;
            
            cell.jiaobiaoLb.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            
            cell.deletBT.tag = indexPath.row;
            
            [cell.deletBT addTarget:self action:@selector(pressDeletBt:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        else if(indexPath.section == 2)
        {
            VLX_buyTicketTableViewCell_4 * cell = [_tabvw dequeueReusableCellWithIdentifier:@"buyTicket4"];
            
            if (!cell) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell = [[VLX_buyTicketTableViewCell_4 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyTicket4"];
            }
            _texdFd3 = cell.phoneTxfd;
            return cell;
        }
        else if(indexPath.section == 3)
        {
//            if (aaaa == 1) {
                VLX_buyTicketTableViewCell_8 * cell = [_tabvw dequeueReusableCellWithIdentifier:@"buyTicket5"];
                if (!cell) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = [[VLX_buyTicketTableViewCell_8 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyTicket5"];
                    if(indexPath.row == 0){
                        cell.jiageLb3.hidden = YES;
                        cell.txfds2.hidden  =  YES;
                        cell.baoxiaoBt.hidden = NO;
                    }
                    else if (indexPath.row == 1){
                        cell.jiageLb3.hidden = NO;
                        cell.txfds2.hidden  =  YES;
                        cell.baoxiaoBt.hidden =YES;
                    }
                    else{
                        cell.jiageLb3.hidden = YES;
                        cell.txfds2.hidden  =  NO;
                        cell.baoxiaoBt.hidden =YES;
//                        cell.txfds2.tag = indexPath.row;
                        if (indexPath.row == 2) {
                           _texdFd4= cell.txfds2;
                        }
                        else if(indexPath.row == 3){
                            _texdFd5= cell.txfds2;
                        }else if (indexPath.row == 4){
                            _texdFd6= cell.txfds2;
                        }
                    }
                    cell.nameLb.text = baoxiaoTitleAry[indexPath.row];
                    
                }
                cell.delegaie = self;
                return cell;

//            }
            
//            else if (aaaa == 5){
//                
//          }
//            if(indexPath.row == 0)
//            {
//                    VLX_buyTicketTableViewCell_8 * cell = [_tabvw dequeueReusableCellWithIdentifier:@"buyTicket5"];
//                    if (cell == nil) {
//                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                            cell = [[VLX_buyTicketTableViewCell_8 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyTicket5"];
//
//                    }
//                    cell.delegaie = self;
//                    return cell;
//            }
//            else if (indexPath.row == 1){
//                
//                VLX_baoxiaoTableViewCell_0 * cell = [_tabvw dequeueReusableCellWithIdentifier:@"buyTicket50"];
//                if (!cell) {
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell = [[VLX_baoxiaoTableViewCell_0 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyTicket50"];
//
//                }
//                return cell;
//   
//            }
//            else{
//                
//                VLX_baoxiaoTableViewCell * cell = [_tabvw dequeueReusableCellWithIdentifier:@"buyTicket51"];
//                if (!cell) {
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell = [[VLX_baoxiaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyTicket51"];
//                    cell.nameLb2.text = baoxiaoTitleAry[indexPath.row-2];
//                return cell;
//            }
//
//        }
//            }  
        }
        else if(indexPath.section == 4)
        {
                VLX_buyTicketTableViewCell_7 * cell = [_tabvw dequeueReusableCellWithIdentifier:@"buyTicket7"];
                
                if (!cell) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = [[VLX_buyTicketTableViewCell_7 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyTicket7"];
                    cell.zhifubaoLb.text = titileAry[indexPath.row];
                    cell.zhifubaoImgvw.image = [UIImage imageNamed:imgAry[indexPath.row]];
                    if (indexPath.row == 0) {
                        cell.selectBt1.selected = YES;
                    }
                }
                
                return cell;
                
        }
    }
    return nil;
}


-(void)abcd:(VLX_buyTicketTableViewCell_8 *)cel
{

    
}

//-(void)abc:(VLX_buyTicketTableViewCell_5 *)cel//意外险,代码OK,目前废弃
//{
//    cel.selectBt.selected = !cel.selectBt.selected;
//    int total;
//    if (cel.selectBt.selected == YES) {
//        total = [_jiageStr intValue]*indexx + [otherStr intValue] *indexx + [baoxianStr intValue]*indexx;
//        isSelect = 1;
//        
//    }
//    else{
//        isSelect = 0;
//        total = [_jiageStr intValue]*indexx + [otherStr intValue]*indexx;
//    }
//    _jiageLb.text = [NSString stringWithFormat:@"¥%d",total];

//}


//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tabvw == tableView) {
        if (indexPath.section == 3)
        {

            
            if (indexPath.row == 0) {
                
                
                NSString * RMBjiageStr = _jiageLb.text;
                
                NSString * jiageValueStr = [RMBjiageStr substringFromIndex:1];//不包含第一位
                
                VLX_buyTicketTableViewCell_8 * cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.baoxiaoBt.selected = !cell.baoxiaoBt.selected;
                if (cell.baoxiaoBt.selected == YES) {
                    
                    aaaa=5;
                    [_tabvw reloadData];
                    
                    int totaljiage = [jiageValueStr intValue] + 20;
                    _jiageLb.text = [NSString stringWithFormat:@"¥%d",totaljiage];

                }
                else{
                    aaaa=1;
                    [_tabvw reloadData];
                    
                    int totaljiage = [jiageValueStr intValue]-20;
                    _jiageLb.text = [NSString stringWithFormat:@"¥%d",totaljiage];

                }
            }

            
        }
        else if (indexPath.section == 4){
            
            if (indexPath.row == 0) {
                VLX_buyTicketTableViewCell_7 * cell = [tableView cellForRowAtIndexPath:indexPath];

                if (cell.selectBt1.selected) {
                    return;
                }
                cell.selectBt1.selected = !cell.selectBt1.selected;
                
                VLX_buyTicketTableViewCell_7 * cel2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:4]];
                cel2.selectBt1.selected = !cel2.selectBt1.selected;
                _pay_ZhifubaoOrWeixin = 0;
            
            }
            else
            {
                
                VLX_buyTicketTableViewCell_7 * cell = [tableView cellForRowAtIndexPath:indexPath];
                if (cell.selectBt1.selected) {
                    return;
                }
                cell.selectBt1.selected = !cell.selectBt1.selected;
                
                VLX_buyTicketTableViewCell_7 * cel2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
                cel2.selectBt1.selected = !cel2.selectBt1.selected;
                _pay_ZhifubaoOrWeixin = 1;
            }

        }
    }
}
////取消选中
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (_tabvw == tableView) {
//        if (indexPath.section == 3)
//        {
//            if      (indexPath.row == 0){
//                VLX_buyTicketTableViewCell_5 * cell = [tableView cellForRowAtIndexPath:indexPath];
//                cell.selectBt.selected = !cell.selectBt.selected;
//                
//                int total;
//                if (cell.selectBt.selected == YES) {
//                    total = [_jiageStr intValue]*indexx + [otherStr intValue]*indexx + [baoxianStr intValue]*indexx;
//                    isSelect = 1;
//                }
//                else{
//                    isSelect = 0;
//                    total = [_jiageStr intValue]*indexx + [otherStr intValue]*indexx;
//                }
//                _jiageLb.text = [NSString stringWithFormat:@"¥%d",total];
//                
//                
//            }
//            else if (indexPath.row == 1){
//                
//            }
//            
//        }
//    }
//    
//}


#pragma mark 底部 （价格 & 提交） 按钮
-(void)makeBt
{
    
    UIView * totalJiageVw = [[UIView alloc]init];//WithFrame:CGRectMake(0, ScreenHeight-64-50, ScreenWidth * 0.608, 50)];
    totalJiageVw.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight - 64-50 , K_SCREEN_WIDTH* 0.608, 50);
    totalJiageVw.backgroundColor = [UIColor whiteColor];
    
    _jiageLb =[[UILabel alloc]initWithFrame:CGRectMake(26, 14, 130, 20)];
    _jiageLb.font = [UIFont systemFontOfSize:20];
//    _jiageLb.text = @"¥998";
    int total = [_jiageStr intValue]*indexx + [_jijianranyoustr intValue]*indexx;
    _jiageLb.text = [NSString stringWithFormat:@"¥%d",total];
    
    _jiageLb.textAlignment = NSTextAlignmentCenter;
    _jiageLb.textColor = rgba(250, 109, 127, 1);
    _jiageLb.userInteractionEnabled = YES;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgrs)];
    [totalJiageVw addGestureRecognizer:tap];
    
    UIImageView * jiageImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(totalJiageVw.frame.size.width -66, 17, 15, 15)];
    jiageImgvw.image =[ UIImage imageNamed:@"价格大"];
    
    
    
    
    
    buyBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth * 0.608, ScreenHeight-64-50, ScreenWidth * 0.392, 50)];
    buyBt.frame = CGRectMake(ScreenWidth * 0.608, K_SCREEN_HEIGHT - kSafeAreaBottomHeight - 64-50 , K_SCREEN_WIDTH* 0.392, 50);
    [buyBt setTitle:@"提交订单" forState:UIControlStateNormal];
    [buyBt addTarget:self action:@selector(pressBuyBt:) forControlEvents:UIControlEventTouchUpInside];
    buyBt.backgroundColor = rgba(230, 83, 35, 1);

    
    
    
    
    
    [totalJiageVw addSubview:_jiageLb];
    [totalJiageVw addSubview:jiageImgvw];
    
    [self.view addSubview:totalJiageVw];
    [self.view addSubview:buyBt];
    
}
-(void)tapgrs
{
    _bigVw1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-200)];
//    _bigVw1.frame = CGRectMake(ScreenWidth/2, K_SCREEN_HEIGHT - kSafeAreaBottomHeight - 50-64 , K_SCREEN_WIDTH/2, 62);
    _bigVw1.backgroundColor = rgba(105, 105, 105, 0.5);
    
    _popView1= [[UIView alloc]init];//WithFrame:CGRectMake(0, ScreenHeight-270-64, ScreenWidth, 222)];
    _popView1.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight - 270-64 , K_SCREEN_WIDTH, 222);
    _popView1.backgroundColor = [UIColor whiteColor];
    
    UILabel * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, 100, 18)];
    lb1.text = @"票价";
    UILabel * lb2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 45+49, 100, 18)];
    lb2.text = @"基建+燃油";
    UILabel * lb3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 45+98, 100, 18)];
    lb3.text = @"快递费";
    
    //三个价格
    UILabel * piaojia_lb1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-140, 45, 69, 18)];
    piaojia_lb1.text = [NSString stringWithFormat:@"¥%d",[_jiageStr intValue]];
    
    UILabel * other_lb1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-140, 45+49, 69, 18)];
    other_lb1.text = [NSString stringWithFormat:@"¥%ld",[_jijianranyoustr intValue] * indexx];
    
    UILabel * baoxiao_lb1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-140, 45+98, 69, 18)];
    baoxiao_lb1.text = @"¥20";
    
    //数量
    UILabel * piaojia_count_lb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-71, 45, 50, 18)];
    piaojia_count_lb.text = [NSString stringWithFormat:@"x%ld",indexx];
    UILabel * other_count_lb1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-71, 45+49, 50, 18)];
    other_count_lb1.text = [NSString stringWithFormat:@"x%ld",indexx];
    UILabel * baoxiao_count_lb1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-71, 45+98, 50, 18)];
    baoxiao_count_lb1.text = @"x1";
    

    
    
    //横分割线
    UILabel * linelb3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 222, ScreenWidth, 1)];
    linelb3.backgroundColor = [UIColor lightGrayColor];
    
    
    
    [_popView1 addSubview:lb1];
    [_popView1 addSubview:lb2];
    
    
    [_popView1 addSubview:piaojia_lb1];
    [_popView1 addSubview:other_lb1];
    
    [_popView1 addSubview:piaojia_count_lb];
    [_popView1 addSubview:other_count_lb1];
    if(aaaa == 5){
        [_popView1 addSubview:lb3];
        [_popView1 addSubview:baoxiao_lb1];
        [_popView1 addSubview:baoxiao_count_lb1];
    }else
    {
        NSLog(@"不显示报销");
    }
    
    
    
    [_popView1 addSubview:linelb3];
    //透明遮挡
    _bigVw2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.608,ScreenHeight)];
    _bigVw2.backgroundColor = [UIColor clearColor];
    
    [_bigVw1 addSubview:_popView1];
    
    [self.view addSubview:_bigVw2];
    [self.view addSubview:_bigVw1];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_bigVw1 removeFromSuperview];
    [_bigVw2 removeFromSuperview];
}
#pragma mark 买票
-(void)pressBuyBt:(UIButton*)Bt
{
    [SVProgressHUD showWithStatus:@"正在前往支付"];//
    //过滤数组中重复的元素
    NSMutableArray * name_meiyouchongfu_Ary = [NSMutableArray array];
    name_meiyouchongfu_Ary = [_name_Ary_dismiss valueForKeyPath:@"@distinctUnionOfObjects.self"];
    NSMutableArray * ID_meiyouchongfu_Ary = [NSMutableArray array];
    ID_meiyouchongfu_Ary = [_ID_NoAry_dismiss valueForKeyPath:@"@distinctUnionOfObjects.self"];
    NSString * name111 = [[NSString alloc]init];
    name111 = [name_meiyouchongfu_Ary componentsJoinedByString:@","];//将数组内的全部内容转成字符串,并用""分割,分割","分割
//    NSLog(@"几个几个:%@",name111);
    NSString * IDcard222 = [[NSString alloc]init];
    IDcard222 = [ID_meiyouchongfu_Ary componentsJoinedByString:@","];//将数组内的全部内容转成字符串,并用""分割,分割","分割

        [NSString setPhoneNum:_texdFd3.text];
        _orderModel_1.phone=[ZYYCustomTool checkNullWithNSString:_texdFd3.text];
        BOOL isFull=[_orderModel_1 checkIsFull_3];
        if (!isFull) {
            //[SVProgressHUD showErrorWithStatus:@"订单信息不正确，请重新输入"];
            return;
        }
        _orderModel_1.name = [ZYYCustomTool checkNullWithNSString:_texdFd1.text];
//        NSLog(@"_order:%@",_orderModel_1.name);
        [NSString setIdNum:_texdFd2.text];
        _orderModel_1.IDCard=[ZYYCustomTool checkNullWithNSString:_texdFd2.text];
        
        BOOL isFull3=[_orderModel_1 checkIsFull_2];
        if (!isFull3) {
            [SVProgressHUD showErrorWithStatus:@"还有乘客信息没有输入完整"];
//            return;
        }else
        {

            NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"createOrder"];//生单
            NSMutableDictionary * para = [NSMutableDictionary dictionary];
            para[@"bookingResult"]=_bookingResult;
            para[@"cardNo"] = IDcard222;
            para[@"contact"] = name111;
            para[@"contactMob"] = _texdFd3.text;

            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString * myselfUserId_0 = [userDefaultes stringForKey:@"alias"];
            NSString *userID = [myselfUserId_0 stringByReplacingOccurrencesOfString:@"vlvxing" withString:@""];
            
            para[@"userid"] = userID;//[NSString getDefaultUser];//获取id
            if (aaaa==5) {
                _orderModel_1.name1 = [ZYYCustomTool checkNullWithNSString:_texdFd4.text];
                _orderModel_1.phone1=[ZYYCustomTool checkNullWithNSString:_texdFd5.text];
                [NSString setIdNum:_texdFd2.text];
                _orderModel_1.address1=[ZYYCustomTool checkNullWithNSString:_texdFd6.text];
                BOOL isFull3=[_orderModel_1 checkIsFull_4];
                if (!isFull3) {
                    [SVProgressHUD showErrorWithStatus:@"报销信息没有输入完整"];
                }else{
                    para[@"attnName"] = _texdFd4.text;
                    para[@"attnPhone"] = _texdFd5.text;
                    para[@"attnAddress"]=_texdFd6.text;
                    NSLog_JSON(@"生单参数有有有有有有有报销:%@",para);
                    [HMHttpTool post:url params:para success:^(id responseObj) {
                        NSLog_JSON(@"有报销生单数据__OK:%@",responseObj);
                        if ([responseObj[@"status"] isEqual:@1]) {
                            NSDictionary * dic = [NSDictionary dictionary];
                            dic = responseObj[@"data"];
                            _orderid = dic[@"result"][@"id"];//订单id
                            _orderNO = dic[@"result"][@"orderNo"];///订单号
                            NSString * zhifuJG = [NSString string];//去掉¥符号
                            zhifuJG = [_jiageLb.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
                            _jiage =  [zhifuJG floatValue]+20; //[dic[@"result"][@"noPayAmount"] floatValue]+20;//jiekou最终应该支付金额

                            [self panduanguoqi];//判断订单是否超过支付时间
//                            [self zhifubaoOrweixin_zhifu];
                        }
                        else if ([responseObj[@"status"] isEqual:@-2]) {
                            [SVProgressHUD showErrorWithStatus:@"数据获取失败"];
                        }
                    } failure:^(NSError *error) {
//                        NSLog_JSON(@"数据__失败:%@",error);
                        [SVProgressHUD showErrorWithStatus:@"支付失败!"];
                    }];
                    }
                }
            else{//aaaa==1
                NSLog_JSON(@"生单参数无无报销参数:%@",para);
                [HMHttpTool post:url params:para success:^(id responseObj) {
                    NSLog(@"无报销生单数据__OK:%@",responseObj);
                    if ([responseObj[@"status"] isEqual:@1]) {
                        NSDictionary * dic = [NSDictionary dictionary];
                        dic = responseObj[@"data"];
                        _orderid = dic[@"result"][@"id"];//订单id
                        _orderNO = dic[@"result"][@"orderNo"];///订单号

                        NSString * zhifuJG = [NSString string];//去掉¥符号
                        zhifuJG = [_jiageLb.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
                        _jiage = [zhifuJG floatValue];// [dic[@"result"][@"noPayAmount"] floatValue];//最终应该支付金额
                        NSLog(@"%f",_jiage);
                        NSLog(@"_jiage::::::::%@",dic);
                        [self panduanguoqi];//判断订单是否超过支付时间
//                        [self zhifubaoOrweixin_zhifu];
                    }
                    else{
                        [SVProgressHUD showInfoWithStatus:@"未获取到生单信息"];
                    }
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"支付失败!"];
                }];
            }
        }
}

#pragma mark 判断订单是否超时过期
-(void)panduanguoqi{
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"orderId"] = _orderid;
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"payValidate"];
    [HMHttpTool post:url params:para success:^(id responseObj) {
        if ([responseObj[@"code"] isEqual:@0]) {
            NSLog(@"可以支付");
            [self zhifubaoOrweixin_zhifu];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"订单超时,请重新预定"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"您的网络有问题,请检查"];
    }];

}



//支付宝或者微信支付
-(void)zhifubaoOrweixin_zhifu{
    
    NSLog(@"最终的包括各种金额%f",_jiage);
    if (_pay_ZhifubaoOrWeixin==1) {//微信
//        NSLog(@"微信");
        float ceshiJiage = 0.01;//测试价格,一分钱
        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
        dataDic[@"token"]=[NSString getDefaultToken];//
        dataDic[@"orderid"]=[NSString stringWithFormat:@"%@",_orderid];//订单id
        dataDic[@"systemtradeno"]=[NSString stringWithFormat:@"%@",_orderNO];//商品id
        dataDic[@"orderprice"]= [NSString stringWithFormat:@"%f",ceshiJiage];//单位:元
//        dataDic[@"orderprice"]= [NSString stringWithFormat:@"%f",_jiage];//单位:元
        NSLog(@"微信支付参数:%@",dataDic);
        [SVProgressHUD dismiss];
        [[PayTool defaltTool] payForServiceWithDic:dataDic withViewController:self withPayType:@"101" SuccessBlock:^{
            NSLog(@"SuccessBlock");
        } failure:^(NSString *errorInfo) {
            NSLog(@"failure:%@",errorInfo);
        }];
        
    }
    else if (_pay_ZhifubaoOrWeixin==0)//支付宝
    {
        NSLog(@"支付宝");
        float ceshiJiage = 0.01;//测试价格,一分钱
        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
        dataDic[@"token"]=[NSString getDefaultToken];
        dataDic[@"orderid"]=[NSString stringWithFormat:@"%@",_orderid];//订单id
        dataDic[@"systemtradeno"]=[NSString stringWithFormat:@"%@",_orderNO];////商品id,
        dataDic[@"orderprice"]=[NSString stringWithFormat:@"%f",ceshiJiage];//allPrice];//,_jiage];//单位:元
//        dataDic[@"orderprice"]= [NSString stringWithFormat:@"%f",_jiage];真实价格
        dataDic[@"servername"]=[ZYYCustomTool checkNullWithNSString:@"V旅行机票"];//订单标题
        NSLog_JSON(@"支付宝支付参数%@",dataDic);
        
        [SVProgressHUD dismiss];
        
        [[PayTool defaltTool]payForServiceWithDic:dataDic withViewController:self withPayType:@"102" SuccessBlock:^{
            NSLog(@"grm支付成功zfb");
        } failure:^(NSString *errorInfo) {
            NSLog(@"grm支付失败%@",errorInfo);
        }];
    }
}
//列表滑动时候
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}


@end
