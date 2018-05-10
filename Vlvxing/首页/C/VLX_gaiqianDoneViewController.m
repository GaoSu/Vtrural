//
//  VLX_gaiqianDoneViewController.m
//  Vlvxing
//
//  Created by grm on 2017/11/21.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_gaiqianDoneViewController.h"

#import "VLX_gaiqianDonetableVwCell.h"

#import "VLX_buyTicketTableViewCell_7.h"
@interface VLX_gaiqianDoneViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel * serverLb ;//航班 准点率 餐食
    UILabel * flyLb1;//起飞机场
    UILabel * downLb1;//降落机场
    UILabel * dateLb1;//日期和星期
    UIButton * changeBt;//改签按钮
    
    UIView * _bigVw2;//弹窗背景半透明
    UIView * _bigVw3;
    UIView * _popView2;//弹窗
    
    NSString * _jiageSt1;//价格
    
    NSArray * titileAry;//支付宝/微信.文字
    NSArray * imgAry;//支付宝/微信.图标
    NSInteger payZhifubao_Or_Weixin;//标记,支付宝0,还是微信1

}

@property(nonatomic,strong)UITableView * chengkeTableVvw;//乘客列表
@property (nonatomic,strong)UILabel * jiageLb1;

@end

@implementation VLX_gaiqianDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton2) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton2)];

    
    self.title = @"改签申请";
    
    titileAry = [NSArray array];
    titileAry = @[@"支付宝",@"微信"];
    imgAry = [NSArray array];
    imgAry =    @[@"alipay",@"WeChat-pay"];
    payZhifubao_Or_Weixin = 0;//默认支付宝

    NSLog(@"tzhuanckshuliang:%ld",_chengkeArray.count);
    self.view.backgroundColor =rgba(240, 240, 240, 1);
    
    self.automaticallyAdjustsScrollViewInsets = NO;//防止frame乱搞

    
    [self makeUI1];

    
    [self makeBt1];
}
-(void)tapLeftButton2{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)makeUI1
{
    _chengkeTableVvw = [[UITableView alloc]initWithFrame:CGRectMake(9, 9, ScreenWidth-18, ScreenHeight-50-80) style:UITableViewStyleGrouped];
    _chengkeTableVvw.delegate = self;
    _chengkeTableVvw.dataSource = self;
    
    [self.view addSubview: _chengkeTableVvw];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return _chengkeArray.count;
    }else{
        return 2;//放两个cell,支付用
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }else{
        return 45;//放两个cell,支付用
    }
}
//头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 140+30;
    }else{
        return 40;//请选择支付方式
    }
}
#pragma mark 自定义的组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {

        UIView * backgroundView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-18, 100)];
        backgroundView1.layer.cornerRadius=6;
        backgroundView1.layer.borderWidth=0.5;
        backgroundView1.layer.borderColor=[rgba(225, 110, 65, 1)CGColor];//CGColor不能少
        backgroundView1.backgroundColor = rgba(225, 110, 65, 1);
        

        UIView * backgroundView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 94, ScreenWidth-18, 37)];
        backgroundView2.backgroundColor = [UIColor whiteColor];
        //    //航班及公司
        UILabel * nameLb1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 10,200 , 20)];
        nameLb1.text = [NSString stringWithFormat:@"%@%@",_name1,_hangbanhaoStr]; //_name1;
        nameLb1.textColor = [UIColor lightGrayColor];
        nameLb1.font = [UIFont systemFontOfSize:14];
        [backgroundView2 addSubview:nameLb1];
        
        //日期和星期
        dateLb1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 200, 16)];
        dateLb1.textColor = [UIColor whiteColor];
        dateLb1.font = [UIFont systemFontOfSize:16];
        dateLb1.text = [NSString  stringWithFormat:@"%@ %@",_date2,_xingqijiStr];//_date2;

        //开始时间
        UILabel * stateTime =[[UILabel alloc]initWithFrame:CGRectMake(5, 38, 90, 23)];
        stateTime.font = [UIFont fontWithName:@"HelveticaNeue-Bold"size:23];//黑粗体
        stateTime.text = _sta3;
        stateTime.textColor = [UIColor whiteColor];
        //结束时间
        UILabel * overTime =[[UILabel alloc]initWithFrame:CGRectMake(backgroundView1.frame.size.width - 6-90, 38, 90, 23)];
        overTime.text = _over4;
        overTime.textColor = [UIColor whiteColor];
        overTime.textAlignment = NSTextAlignmentRight;
        overTime.font = [UIFont fontWithName:@"HelveticaNeue-Bold"size:23];
        //总时长
        UILabel * totalTime = [[UILabel alloc]initWithFrame:CGRectMake(backgroundView1.frame.size.width / 2 -38, 40, 76, 12)];
        totalTime.textAlignment = NSTextAlignmentCenter;
        totalTime.text = _total5;
        totalTime.textColor = [UIColor whiteColor];
        totalTime.font = [UIFont systemFontOfSize:12];
        //线
        UILabel * line4 = [[UILabel alloc]initWithFrame:CGRectMake(backgroundView1.frame.size.width / 2 -49, 50, 98, 1)];
        line4.backgroundColor = [UIColor lightGrayColor];
        
        //起飞机场14
        flyLb1 =[[UILabel alloc]initWithFrame:CGRectMake(6, 71, 130, 14)];
        flyLb1.font = [UIFont systemFontOfSize:14];
        flyLb1.textColor = [UIColor whiteColor];
        flyLb1.text = _fly7;
        //降落机场
        downLb1 =[[UILabel alloc]initWithFrame:CGRectMake(backgroundView1.frame.size.width-6-130, 71, 130, 14)];
        downLb1.font = [UIFont systemFontOfSize:14];
        downLb1.text = _down8;
        downLb1.textColor =[UIColor whiteColor];
        downLb1.textAlignment = NSTextAlignmentRight;
        
        
        
        
        
        [backgroundView1 addSubview:dateLb1];
        [backgroundView1 addSubview:stateTime];
        [backgroundView1 addSubview:overTime];
        [backgroundView1 addSubview:totalTime];
        [backgroundView1 addSubview:line4];
        [backgroundView1 addSubview:flyLb1];
        [backgroundView1 addSubview:downLb1];
        

        UILabel  * lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, ScreenWidth-18, 30)];
        lb.text = @"      乘客列表";
        lb.backgroundColor = [UIColor whiteColor];
        lb.textColor = [UIColor lightGrayColor];
        lb.font = [UIFont systemFontOfSize:14];

        
        
        
        UIView * headerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-18 , 44)];
        

        
        [headerVw addSubview:backgroundView1];
        [headerVw addSubview:backgroundView2];
        [headerVw addSubview:lb];
        
        return headerVw;
        
    }else{
        //请选择支付方式
        UIView * headerVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-18 , 44)];
        
        headerVw.backgroundColor = [UIColor whiteColor];
        
        UILabel  * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 14, 100, 15)];
        lb1.text = @"请选择支付方式";
        lb1.textColor = [UIColor lightGrayColor];
        lb1.font = [UIFont systemFontOfSize:14];
        
        [headerVw addSubview:lb1];
        
        return headerVw;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        static NSString * id = @"cell";
        VLX_gaiqianDonetableVwCell *cell = [_chengkeTableVvw dequeueReusableCellWithIdentifier:id];
        if (!cell) {
            cell = [[VLX_gaiqianDonetableVwCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:id];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_chengkeArray.count > 0) {
                cell.nameLb5.text = _chengkeArray[indexPath.row][@"contactName"];
                cell.numberLB5.text = _chengkeArray[indexPath.row][@"phone"];
            }
        }
        return cell;
    }
    else{
        static NSString * id = @"cell";
        
        VLX_buyTicketTableViewCell_7 *cell = [_chengkeTableVvw dequeueReusableCellWithIdentifier:id];
        if (!cell) {
            cell = [[VLX_buyTicketTableViewCell_7 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:id];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.zhifubaoLb.text = titileAry[indexPath.row];
            cell.zhifubaoImgvw.image = [UIImage imageNamed:imgAry[indexPath.row]];
            if (indexPath.row == 0) {
                cell.selectBt1.selected = YES;
            }
        }
        
        return cell;
    }
 
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            VLX_buyTicketTableViewCell_7 * cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (cell.selectBt1.selected) {
                return;
            }
            cell.selectBt1.selected = !cell.selectBt1.selected;
            
            VLX_buyTicketTableViewCell_7 * cel2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            cel2.selectBt1.selected = !cel2.selectBt1.selected;
            payZhifubao_Or_Weixin = 0;
            
        }
        else
        {
            
            VLX_buyTicketTableViewCell_7 * cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.selectBt1.selected) {
                return;
            }
            cell.selectBt1.selected = !cell.selectBt1.selected;
            
            VLX_buyTicketTableViewCell_7 * cel2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            cel2.selectBt1.selected = !cel2.selectBt1.selected;
            payZhifubao_Or_Weixin = 1;
        }


    }
}

-(void)makeBt1
{

    
        UIView * totalJiageVw = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-50, ScreenWidth * 0.608, 50)];
        totalJiageVw.backgroundColor = [UIColor whiteColor];
        
        _jiageLb1 =[[UILabel alloc]initWithFrame:CGRectMake(26, 14, 130, 20)];//17号字
        _jiageLb1.font = [UIFont systemFontOfSize:20];
    _jiageLb1.text = _allfee;
        
        _jiageLb1.textAlignment = NSTextAlignmentCenter;
        _jiageLb1.textColor = rgba(250, 109, 127, 1);
        _jiageLb1.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgrs1)];
        [totalJiageVw addGestureRecognizer:tap];
        
        UIImageView * jiageImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(totalJiageVw.frame.size.width -66, 17, 15, 15)];
        jiageImgvw.image =[ UIImage imageNamed:@"价格大"];
        
        
        
        
        
        changeBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth * 0.608, ScreenHeight-64-50, ScreenWidth * 0.392, 50)];
        [changeBt setTitle:@"确认改签" forState:UIControlStateNormal];
        [changeBt addTarget:self action:@selector(pressgaiqian1) forControlEvents:UIControlEventTouchUpInside];
        changeBt.backgroundColor = rgba(230, 83, 35, 1);
        
        
        
        
        
        
        [totalJiageVw addSubview:_jiageLb1];
        [totalJiageVw addSubview:jiageImgvw];
        
        [self.view addSubview:totalJiageVw];
        [self.view addSubview:changeBt];
}

-(void)tapgrs1
{
    _bigVw2 = [[UIView alloc]initWithFrame:CGRectMake(0, -15, ScreenWidth, ScreenHeight-100)];
    _bigVw2.backgroundColor = rgba(105, 105, 105, 0.5);
    
    _popView2= [[UIView alloc]init];//WithFrame:CGRectMake(0, ScreenHeight-334+90+15, ScreenWidth, 222-90)];
    _popView2.frame = CGRectMake(0, K_SCREEN_HEIGHT - kSafeAreaBottomHeight - 334+90+15 , K_SCREEN_WIDTH, 222-90);
    _popView2.backgroundColor = [UIColor whiteColor];
    
    UILabel * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, 100, 18)];
    lb1.text = @"改签费";

    
    //1个价格
    UILabel * piaojia_lb1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-140, 45, 69, 18)];
    piaojia_lb1.text = _allfee;
    
    //数量
    UILabel * piaojia_count_lb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-71, 45, 50, 18)];
    piaojia_count_lb.text = [NSString stringWithFormat:@"x%ld",_chengkeArray.count];


    //横分割线
    UILabel * linelb3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 222-90, ScreenWidth, 1)];
    linelb3.backgroundColor = [UIColor lightGrayColor];
    
    
    
    [_popView2 addSubview:lb1];
    
    [_popView2 addSubview:piaojia_lb1];
    
    [_popView2 addSubview:piaojia_count_lb];

    
    
    [_popView2 addSubview:linelb3];
    //透明遮挡
    _bigVw3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.608,ScreenHeight)];
    _bigVw3.backgroundColor = [UIColor clearColor];
    
    [_bigVw2 addSubview:_popView2];
    
    [self.view addSubview:_bigVw3];
    [self.view addSubview:_bigVw2];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_bigVw2 removeFromSuperview];
    [_bigVw3 removeFromSuperview];
    
}

//
-(void)pressgaiqian1{
    
    
    [SVProgressHUD showWithStatus:@"正在生成改签订单"];
        NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"applyChange"];//不能真走
    NSMutableDictionary * para = [[NSMutableDictionary alloc]init];
    para[@"orderNo"]=  _orderNo;//@"chu171124173403029";//_orderNo;//@"";//订单号//这个需要从新写
    para[@"changeCauseId"] = @"1";//后台说可以随便写,
    
    NSString * str1 = [[NSString alloc]init];
    str1 = [_passengeridArray componentsJoinedByString:@","];
    para[@"passengerIds"] = str1;//_jiadePassengerid;//乘机人id
    para[@"applyRemarks"]=@"1";
    para[@"uniqKey"] = _uniqKey;//@"a7fe2e18101faf6a943a64b833d8a879";//从订单查询返回,这个需要从新写
    para[@"gqFee"] = _gqfee;//改签费
    para[@"upgradeFee"]=_upgradeFee;//升舱费
    para[@"flightNo"] =_hangbanhaoStr;//航班号
    para[@"cabinCode"]=_cabinCodeStr;///升舱仓位
    para[@"startDate"]=_date2;//开始日期
    para[@"startTime"]=_sta3;//起飞时间
    para[@"endTime"]=_over4;//到达时间
    NSString * zhifujiageStr = [_allfee substringFromIndex:1];//掐掉人民币¥符号
//    NSLog(@"截掉¥符号%@",zhifujiageStr);
    para[@"allFee"]=zhifujiageStr;//总价
    NSLog(@"申请改签参数%@",para);
    
    [HMHttpTool post:url params:nil success:^(id responseObj) {
        NSLog_JSON(@"%@",responseObj);
        [SVProgressHUD dismiss];
        if([responseObj[@"status"] isEqual:@1]){
            
            NSDictionary * dic1 =[NSDictionary dictionary];
            NSDictionary * dic2 =[NSDictionary dictionary];

            for (dic1 in responseObj[@"data"][@"result"]) {
                NSLog(@"dic1::%@",dic1);
//                NSLog(@"----%@",dic1[@"ticketNum"]);
//                NSLog(@"_____%@",dic1[@"changeApplyResult"][@"orderId"]);
//                
                
                _order_ID = dic1[@"changeApplyResult"][@"orderId"];
                _orderNo = dic1[@"changeApplyResult"][@"orderNo"];

            }
            

            


            [self loadChangePay];
        }
        else{
            
        }
    } failure:^(NSError *error) {
        NSLog_JSON(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"申请改签失败"];
    }];
    
}
//改签支付
-(void)loadChangePay{
    
//    [SVProgressHUD showWithStatus:@"正在前往支付"];//

    
        NSString * zhifujiageStr = [_allfee substringFromIndex:1];
    NSLog(@"截掉¥符号%@",zhifujiageStr);
    
    float allPrice = [zhifujiageStr floatValue];
    float allPrice001 = 0.01;//假的价格
    [SVProgressHUD showWithStatus:@"正在改签"];
    sleep(1.0f);
    if (allPrice == 0) {
        [SVProgressHUD showWithStatus:@"改签成功"];
    }else{
    
    
    if (payZhifubao_Or_Weixin==1) {//微信
        NSLog(@"微信");
        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
        dataDic[@"token"]=[NSString getDefaultToken];//
        dataDic[@"orderid"]=[NSString stringWithFormat:@"%@",_order_ID];//订单id
        dataDic[@"systemtradeno"]=[NSString stringWithFormat:@"%@",_orderNo];//商品id
        dataDic[@"orderprice"]=[NSString stringWithFormat:@"%f",allPrice];//,_jiage];//单位:元
        NSLog(@"微信字典%@",dataDic);
        [SVProgressHUD dismiss];
        [[PayTool defaltTool] payForServiceWithDic:dataDic withViewController:self withPayType:@"101" SuccessBlock:^{
            NSLog(@"SuccessBlock");
        } failure:^(NSString *errorInfo) {
            NSLog(@"failure:%@",errorInfo);
        }];
        
    }
    else if (payZhifubao_Or_Weixin==0)//支付宝
    {
        NSLog(@"支付宝");
        
        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
        dataDic[@"token"]=[NSString getDefaultToken];
        dataDic[@"orderid"]=[NSString stringWithFormat:@"%@",_order_ID];//订单id
        dataDic[@"systemtradeno"]=[NSString stringWithFormat:@"%@",_orderNo];////商品id,
        dataDic[@"orderprice"]=[NSString stringWithFormat:@"%f",allPrice];//,_jiage];//单位:元
        //            dataDic[@"servername"]=[ZYYCustomTool checkNullWithNSString:_detailModel.data.productname];
        dataDic[@"servername"]=[ZYYCustomTool checkNullWithNSString:@"V旅行机票"];//订单标题
        NSLog(@"支付宝信字典%@",dataDic);
        
        [SVProgressHUD dismiss];
        
        [[PayTool defaltTool]payForServiceWithDic:dataDic withViewController:self withPayType:@"102" SuccessBlock:^{
            NSLog(@"grm支付成功zfb");
        } failure:^(NSString *errorInfo) {
            NSLog(@"grm支付失败%@",errorInfo);
        }];
    }
    
    }
    
    
    
}

@end
