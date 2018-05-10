//
//  VLX_tuipiao_OK_VC.m
//  Vlvxing
//
//  Created by grm on 2017/11/13.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_tuipiao_OK_VC.h"

#import "VLX_tuipiaoDoneTbvwCell.h"
#import "VLXHomeController.h"
#import "VLX_TicketViewController.h"

#import "HMHttpTool.h"


// 定义Block
typedef void(^BackBlock)(void);

/**
 *  创建团队
 */
@interface CreatTeam : VLX_TicketViewController

//// 创建一个Block的实例
//@property (nonatomic, copy) BackBlock backBlock;

@end


@interface VLX_tuipiao_OK_VC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * nameAry     ;
    NSMutableArray * idcardNoary ;
    NSMutableArray * typePiaoAry ;
    NSMutableArray * jiageAry    ;
    NSMutableArray * jiage1Ary   ;
    NSMutableArray * jiage2Ary   ;
    
    
    UIView * bigBackVw;//
    NSString * yewuhaostr;//退票成功业务号

}

// 创建一个Block的实例
@property (nonatomic, copy) BackBlock backBlock;

@property (nonatomic,strong)NSString * successStr;//退票成功否?
@property (nonatomic,strong)NSString * reasonstr;

@property (nonatomic,strong)UITableView * chengkeInfoTbvw;//乘客信息tableview
@property (nonatomic,strong)NSMutableArray * passengeridArray;


@end

@implementation VLX_tuipiao_OK_VC

-(void)loadChaxunData{
    
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"refundSearch"];
    
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"orderNo"]=_orderno1;
    
    [HMHttpTool post:url params:para success:^(id responseObj) {
//        NSLog_JSON(@"成功:%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            
            if ([responseObj[@"data"] isKindOfClass:[NSNull class]]) {
                _successStr = @"okNull";
                _reasonstr = responseObj[@"message"];
                [self makeMineUI53];
            }
            else{
                _successStr = @"ok";
                _reasonstr = responseObj[@"message"];
                
                NSArray * aryyy111 = responseObj[@"data"][@"baseOrderInfo"];
//                NSLog(@"%ld",aryyy111.count);//1
//                NSLog(@"%@",aryyy111[0][@"statusDesc"]);//
                
                NSDictionary * dic1 = [[NSDictionary alloc]init];
                NSDictionary * dic2 = [[NSDictionary alloc]init];
                
                for (dic1 in responseObj[@"data"][@"infoList"]) {
//                    NSLog(@"%@",dic1[@"basePassengerPriceInfo"]);
                    
                    [nameAry addObject:dic1[@"basePassengerPriceInfo"][@"passengerName"]];
                    [idcardNoary addObject:dic1[@"basePassengerPriceInfo"][@"cardNum"]];
                    [typePiaoAry addObject:dic1[@"basePassengerPriceInfo"][@"passengerTypeStr"]];
                    [jiageAry addObject:dic1[@"basePassengerPriceInfo"][@"ticketPrice"]];//机票价格,可能有用
                    [_passengeridArray addObject:dic1[@"basePassengerPriceInfo"][@"passengerId"]];
                }
                
                for (dic2 in responseObj[@"data"][@"infoList"]) {
//                    NSLog(@"%@",dic2[@"refundFeeInfo"]);
                    [jiage1Ary addObject:dic2[@"refundFeeInfo"][@"refundFee"]];
                    [jiage2Ary addObject:dic2[@"refundFeeInfo"][@"returnRefundFee"]];

                }
                
                [self tanchuangVw];
//                [self makeMineUI53];

            }
            
            
        }else{
            
            _successStr = @"fail";
            _reasonstr = responseObj[@"message"];
        }
        
        
        
        
    } failure:^(NSError *error) {
        NSLog_JSON(@"失败:%@",error);
        _successStr = @"fail";
//        [self makeMineUI54];
    }];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton53) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton53)];

    self.title = @"退票信息及结果";
    
    self.view.backgroundColor = rgba(245, 245, 245, 1);
    
    
    nameAry        = [NSMutableArray array];
    idcardNoary    = [NSMutableArray array];
    typePiaoAry    = [NSMutableArray array];
    jiageAry       = [NSMutableArray array];
    jiage1Ary      = [NSMutableArray array];
    jiage2Ary      = [NSMutableArray array];
    
    _passengeridArray = [NSMutableArray array];
    [self loadChaxunData];
    
    
//    [self makeMineUI53];
    
}
-(void)tapLeftButton53
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeMineUI53
{
    //一,vw
    UIScrollView * scrView = [[UIScrollView alloc]init];
    scrView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-59);
    scrView.contentSize = CGSizeMake(0, ScreenHeight);
    scrView.showsHorizontalScrollIndicator = NO;
    scrView.showsVerticalScrollIndicator = NO;
    //(小一vw)
    UIView * view1  = [[UIView alloc]initWithFrame:CGRectMake(0, 7, ScreenWidth, 159)];
    view1.backgroundColor = [UIColor whiteColor];
    
    UITextView * lb1 = [[UITextView alloc]initWithFrame:CGRectMake(10, 25, ScreenWidth-30, 49)];
    UITextView * txvd2 = [[UITextView alloc]initWithFrame:CGRectMake(10, 62, ScreenWidth-30, 100)];
    txvd2.backgroundColor = [UIColor clearColor];
    if ([_successStr isEqualToString:@"ok"]) {
        lb1.text = @"恭喜,您已退票成功,请牢记业务号:";
        lb1.textColor = [UIColor grayColor];
        lb1.font = [UIFont systemFontOfSize:18];
        txvd2.text = yewuhaostr;//
        txvd2.textColor = rgba(230, 87, 36, 1);
        txvd2.font = [UIFont systemFontOfSize:18];
    }
    else if([_successStr isEqualToString:@"okNull"]){
        lb1.text = _reasonstr;
        lb1.textColor = rgba(230, 87, 36, 1);
        lb1.font = [UIFont systemFontOfSize:16];
//        txvd2.text = _reasonstr;
//        txvd2.textColor = [UIColor grayColor];
//        txvd2.font = [UIFont systemFontOfSize:16];
    }
    else if([_successStr isEqualToString:@"fail"]){
        lb1.text = _reasonstr;
        lb1.textColor = rgba(230, 87, 36, 1);
        lb1.font = [UIFont systemFontOfSize:18];
//        txvd2.text = _reasonstr;
//        txvd2.textColor = [UIColor grayColor];
//        txvd2.font = [UIFont systemFontOfSize:16];
    }
    else if([_successStr isEqualToString:@"netErr"]){
        lb1.text = @"网络故障";
        lb1.textColor = rgba(230, 87, 36, 1);
        lb1.font = [UIFont systemFontOfSize:18];
    }
    
    
    [view1 addSubview:lb1];
    [view1 addSubview:txvd2];

    
    
    //(小二vw)
    UIView * view2  = [[UIView alloc]initWithFrame:CGRectMake(0, 159+7+7, ScreenWidth, ScreenHeight-(159+7+7+7+59+64))];
    view2.backgroundColor = [UIColor whiteColor];

    UITextView * nameLb = [[UITextView alloc]initWithFrame:CGRectMake(8, 25, ScreenWidth-12, view2.frame.size.height-30)];
    nameLb.text = @"退票须知:";
    nameLb.font = [UIFont systemFontOfSize:16];
    nameLb.textColor = [UIColor grayColor];
    
    [view2 addSubview:nameLb];

    
    
    
    [scrView addSubview:view1];
    [scrView addSubview:view2];
    
    
    
    //二,vw
    UIView * buttomVw = [[UIView alloc]init];//WithFrame:CGRectMake(0, ScreenHeight-59-64, ScreenWidth, 59)];
    buttomVw.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight - 59-64 , K_SCREEN_WIDTH, 59);
    buttomVw.backgroundColor = [UIColor whiteColor];
    
    UIButton * gaiqianBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
    gaiqianBt.backgroundColor = [UIColor whiteColor];
    [gaiqianBt addTarget:self action:@selector(pressJixugoupiaonBt) forControlEvents:UIControlEventTouchUpInside];
    [gaiqianBt setTitle:@"继续购票" forState:UIControlStateNormal];
    [gaiqianBt setTitleColor:rgba(230, 87, 36, 1) forState:UIControlStateNormal];
    [gaiqianBt setFont:[UIFont systemFontOfSize:13]];
    [gaiqianBt setImage:[UIImage imageNamed:@"ios—继续购票—大"] forState:UIControlStateNormal];
    //按钮图片文字上下:
    gaiqianBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [gaiqianBt setTitleEdgeInsets:UIEdgeInsetsMake(gaiqianBt.imageView.frame.size.height+10 ,-gaiqianBt.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [gaiqianBt setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,0.0, -gaiqianBt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
    
    
    UIButton * tuipiaoBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 50)];
    tuipiaoBt.backgroundColor = [UIColor whiteColor];
    [tuipiaoBt addTarget:self action:@selector(presschaxundingdanBt) forControlEvents:UIControlEventTouchUpInside];
    [tuipiaoBt setTitle:@"查询订单" forState:UIControlStateNormal];
    [tuipiaoBt setTitleColor:rgba(230, 87, 36, 1) forState:UIControlStateNormal];
    [tuipiaoBt setFont:[UIFont systemFontOfSize:13]];
    [tuipiaoBt setImage:[UIImage imageNamed:@"ios—查询订单—大"] forState:UIControlStateNormal];//这个图没有经过打包,所以必须要改名字xingwuy@3x,不然会造成图片太大无法控制
    //按钮图片文字上下:
    tuipiaoBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [tuipiaoBt setTitleEdgeInsets:UIEdgeInsetsMake(tuipiaoBt.imageView.frame.size.height+10 ,-tuipiaoBt.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [tuipiaoBt setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,0.0, -tuipiaoBt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
    [buttomVw addSubview:gaiqianBt];
    [buttomVw addSubview:tuipiaoBt];
    
    
    
    [self.view addSubview:buttomVw];
    [self.view addSubview:scrView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//跳转到哪儿?????????????
-(void)pressJixugoupiaonBt
{
    //思路: 不对控制器数组中的元素做改变，直接在控制器数组中找到想要跳转的那个控制器所在的位置，获取到该控制器，然后进行pop。
    NSInteger num = self.navigationController.viewControllers.count;//获取从第一个pushview过来开始计算有几个导航控制器
    if (num > 5) {
        UIViewController *popVC =    self.navigationController.viewControllers[num - 5];
        [self.navigationController popToViewController:popVC animated:YES];
    }

}

-(void)presschaxundingdanBt
{
    NSInteger num = self.navigationController.viewControllers.count;
    if (num > 5) {
        UIViewController *popVC =    self.navigationController.viewControllers[num - 4];
        [self.navigationController popToViewController:popVC animated:YES];
    }
}


-(void)tanchuangVw{
    bigBackVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-62)];//大灰背景
    bigBackVw.backgroundColor = rgba(95, 95, 95, 0.5);
    
    [self.view addSubview:bigBackVw];//预先加载上去,不然列表会崩溃
    
    _chengkeInfoTbvw = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20, ScreenHeight-150) style:UITableViewStyleGrouped];
    _chengkeInfoTbvw.delegate = self;
    _chengkeInfoTbvw.dataSource = self;
    _chengkeInfoTbvw.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    
    UIButton * tuipiaoBt =[[ UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 45, ScreenHeight-120, 90, 31)];
    tuipiaoBt.layer.cornerRadius = 6;
    tuipiaoBt.backgroundColor =rgba(225, 110, 70, 1);
    [tuipiaoBt setTitle:@"确定退票" forState:UIControlStateNormal];
    [tuipiaoBt addTarget:self action:@selector(presstuipiaoBt2) forControlEvents:UIControlEventTouchUpInside];
    

    [bigBackVw addSubview:_chengkeInfoTbvw];
    [bigBackVw addSubview:tuipiaoBt];
    
  
}
-(void)presstuipiaoBt2
{
    bigBackVw.hidden = YES;
    
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"applyRefund"];//@"hhhhhhhhhhhhhhh"];//
    
//    NSString * url = [NSString stringWithFormat:@"%@",@"http://app.mtvlx.cn/ticket/test2/"];
    NSMutableDictionary * para = [[NSMutableDictionary alloc]init];
    para[@"orderNo"]= _orderno1;//@"11111";
    para[@"refundCauseId"]=@"1";//选填,可任意
    NSString * str3 = [[NSString alloc]init];
    str3 = [_passengeridArray componentsJoinedByString:@","];
    para[@"passengerIds"] = str3;//多个ID以逗号分隔
    para[@"returnRefundFee"] = [NSString stringWithFormat:@"%@",(id)jiage2Ary[0]];

    NSLog(@"退票参数%@",para);
    [HMHttpTool post:url params:para success:^(id responseObj) {
        NSLog(@"tuipiaoOk:%@",responseObj);
        if ([responseObj[@"status"] isEqual:@1]) {
            
            if (![responseObj[@"data"] isKindOfClass:[NSNull class]]) {
                
                for (NSDictionary *dic in responseObj[@"data"][@"result"]) {
//                    NSLog(@"ticketNum3:%@",dic[@"ticketNum"]);
                    yewuhaostr = dic[@"ticketNum"];
                    [self makeMineUI53];//ticketNum业务号
                }
                
            }else
            {
                NSLog(@"返回的为空data为空");
                _successStr = @"netErr";
                [self makeMineUI53];
            }
        
        
        
            
        }
        else{
            
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"TUIPIAO_Fail%@",error);
        
        _successStr = @"netErr";
        [self makeMineUI53];
        

    }];
    
    
    
}


#pragma mark 代理
//组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return nameAry.count;
    
}
//高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;

}

//头高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
//尾高
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 55;
}
#pragma mark 自定义的组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , 44)];
    
    headerVw.backgroundColor = [UIColor whiteColor];
    
    UILabel  * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(23, 14, 75, 15)];
    lb1.text = @"机票状态:";
    lb1.textColor = [UIColor lightGrayColor];
    lb1.font = [UIFont systemFontOfSize:14];
    
    UILabel  * lb2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 14, 100, 15)];
    lb2.text = @"已出票";
    lb2.textColor = [UIColor lightGrayColor];
    lb2.font = [UIFont systemFontOfSize:14];
    
    [headerVw addSubview:lb1];
    [headerVw addSubview:lb2];

    return headerVw;

}
#pragma mark 自定义的组尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , 52)];
    
    footerVw.backgroundColor = [UIColor whiteColor];
    

    UILabel  * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 14, 60, 15)];
    lb1.text = @"退票费";
    lb1.textColor = [UIColor lightGrayColor];
    lb1.font = [UIFont systemFontOfSize:14];
    UILabel  * lb2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 60, 15)];
    lb2.text = @"应退金额";
    lb2.textColor = [UIColor lightGrayColor];
    lb2.font = [UIFont systemFontOfSize:14];
    

    UILabel  * lb3 = [[UILabel alloc]initWithFrame:CGRectMake(70, 14, 60, 15)];
    lb3.text = [NSString stringWithFormat:@"¥%@",(id)jiage1Ary[0]];
    lb3.textColor = [UIColor lightGrayColor];
    lb3.font = [UIFont systemFontOfSize:14];
    UILabel  * lb4 = [[UILabel alloc]initWithFrame:CGRectMake(70, 30, 60, 15)];
    lb4.text = [NSString stringWithFormat:@"¥%@",(id)jiage2Ary[0]];
    lb4.textColor = [UIColor lightGrayColor];
    lb4.font = [UIFont systemFontOfSize:14];
    
    UILabel  * lb5 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-40, 14, 60, 15)];
    lb5.text = [NSString stringWithFormat:@"x%ld",jiage1Ary.count];//@"x1";
    lb5.textColor = [UIColor lightGrayColor];
    lb5.font = [UIFont systemFontOfSize:14];
    UILabel  * lb6 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-40, 30, 60, 15)];
    lb6.text = [NSString stringWithFormat:@"x%ld",jiage2Ary.count];
    lb6.textColor = [UIColor lightGrayColor];
    lb6.font = [UIFont systemFontOfSize:14];
    
    
    
    [footerVw addSubview:lb1];
    [footerVw addSubview:lb2];
    [footerVw addSubview:lb3];
    [footerVw addSubview:lb4];
    [footerVw addSubview:lb5];
    [footerVw addSubview:lb6];

    return footerVw;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    VLX_tuipiaoDoneTbvwCell * cell = [_chengkeInfoTbvw dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[VLX_tuipiaoDoneTbvwCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        NSLog(@"%@",nameAry[indexPath.row]);
        cell.nameLb6.text = nameAry[indexPath.row];
        cell.numberLB6.text = idcardNoary[indexPath.row];
        cell.ticketTyp6.text = typePiaoAry[indexPath.row];
    }
    
    return cell;
    
    
    
}


@end
