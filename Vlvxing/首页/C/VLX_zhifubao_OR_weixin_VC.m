

//
//  VLX_zhifubao_OR_weixin_VC.m
//  Vlvxing
//
//  Created by grm on 2017/11/21.
//  Copyright © 2017年 王静雨. All rights reserved.
//

#import "VLX_zhifubao_OR_weixin_VC.h"//未支付订单,即将支付,有个校验流程,判断该订单是否还有效,无效则不能支付

@interface VLX_zhifubao_OR_weixin_VC (){
    UIView * zfbVw ;
    UIButton * selectBt1;
    UIView * weixinVw;
    UIButton * selectBt2;
}

@property (nonatomic,strong)UILabel * nameLb;
@property (nonatomic,strong)UILabel * shenfenzhengLb;
@property (nonatomic,strong)UILabel * PhoneONLb;
@property (nonatomic,assign)NSInteger zfbORweixin;//0微信,,1支付宝
@property (nonatomic,strong)NSString * zhuangtaiString;//是否可支付

@end

@implementation VLX_zhifubao_OR_weixin_VC

-(void)loadOKorFail{
    _zhuangtaiString = [[NSString alloc]init];
    _zhuangtaiString = @"";
    
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"orderNo"]=_orderno;
    
    NSString * url = [NSString stringWithFormat:@"%@%@",tangyangURL,@"getFlyorderStatus"];//@"http://192.168.1.109:8080/get";//getFlyOrderStatu
    
    [HMHttpTool get:url params:para success:^(id responseObj) {
        NSLog_JSON(@"成功%@",responseObj);
        NSLog(@"成功2%@",responseObj[@"message"]);
        _zhuangtaiString = responseObj[@"message"];
        NSLog(@"成功3%@",_zhuangtaiString);

        [self makeMineUI2];
        
    } failure:^(NSError *error) {
        NSLog(@"失败%@",error);
        
        [self makeMineUI2];
    }];
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"详情";
    
    //左边按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@"return-red"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(tapLeftButton6) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarButton;

    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-red"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [leftButon setTarget:self];
    self.navigationItem.leftBarButtonItem = leftButon;
    self.navigationController.navigationBar.tintColor = orange_color;//原色;
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 50);
    [self.navigationItem.leftBarButtonItem setAction:@selector(tapLeftButton6)];

    
    [self xingqizhuanhuan2:_flyDatesStr];
    _zfbORweixin=0;//默认支付宝
    
    [self loadOKorFail];
    
//    [self makeMineUI2];


}
-(void)tapLeftButton6
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeMineUI2{
    //一,vw
    UIScrollView * scrView = [[UIScrollView alloc]init];
    scrView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-59-100);
    scrView.contentSize = CGSizeMake(0, ScreenHeight+135*(_chengkexinxiAry.count - 1));
    scrView.showsHorizontalScrollIndicator = NO;
    scrView.showsVerticalScrollIndicator = NO;
    //(小一vw)
    UIView * view1  = [[UIView alloc]initWithFrame:CGRectMake(0, 7, ScreenWidth, 159)];
    view1.backgroundColor = [UIColor whiteColor];
    
    UILabel * dateLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 140, 15)];
    dateLb.text = _flyDatesStr;//2017-11-11;
    dateLb.font = [UIFont systemFontOfSize:15];
    
    UILabel * xingqiLb = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 140, 15)];
    xingqiLb.text = _xingqijiStr;//星期三
    xingqiLb.font = [UIFont systemFontOfSize:15];
    
    
    UILabel * area1 = [[UILabel alloc]init];//WithFrame:CGRectMake(110+30+20, 5, 100, 15)];
    area1.text = [NSString stringWithFormat:@"%@ - ",_flyCityStr];//@"北京";
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *font1 = [UIFont fontWithName:@"Helvetica" size:15.0f];
    area1.font = font1;
    // 根据字体得到NSString的尺寸
    CGSize size1 = [area1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,nil]];
    // 名字的W
    CGFloat nameW = size1.width;
    area1.frame = CGRectMake(110+30+20,5, nameW,15);
    
    
    
    
    UILabel * area2 = [[UILabel alloc]initWithFrame:CGRectMake(110+30+20+area1.frame.size.width, 5, 100, 15)];
    area2.text = _downCityStr;//上海";
    area2.font = [UIFont systemFontOfSize:15];
    
    UILabel * time1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 60, 20)];
    
    NSString * bb = [_flyTimeStr substringFromIndex:3];//从第六位开始往后截取,第6位之后(包含)的所有字符串
    time1.text = bb;//@"20:45";
    time1.font = [UIFont systemFontOfSize:20];
    
    UILabel * time2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-60-10, 50, 60, 20)];
    time2.text = _downTimeStr;//@"22:25";
    time2.textAlignment = NSTextAlignmentRight;
    time2.font = [UIFont systemFontOfSize:20];
    
    UILabel * totaltTime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 52, 100, 14)];
    totaltTime.text = _zongshichang;//@"2小时45分钟";
    totaltTime.textColor =[UIColor lightGrayColor];
    totaltTime.textAlignment = NSTextAlignmentCenter;
    totaltTime.font = [UIFont systemFontOfSize:14];
    
    //    UILabel * totaltTime_line = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 52+15, 100, 1)];
    //    totaltTime_line.backgroundColor =[UIColor lightGrayColor];
    
    UIImageView * imgvw = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 52+15, 100, 5)];
    imgvw.image = [UIImage imageNamed:@"ios—去往—大grm.psd"];
    
    
    UILabel * jichang1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 88, 60, 14)];
    jichang1.text = _flyPortStr;//@"首都机场";
    jichang1.textColor =rgba(230, 87, 36, 1);
    jichang1.font = [UIFont systemFontOfSize:14];
    
    UILabel * jichang2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-60-10, 88, 60, 14)];
    jichang2.text = _downportStr;//@"新疆机场";
    jichang2.textColor =rgba(230, 87, 36, 1);
    jichang2.textAlignment = NSTextAlignmentRight;
    jichang2.font = [UIFont systemFontOfSize:14];
    
    UILabel * fuwuzhiliangLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 115, ScreenWidth-20, 14)];
    fuwuzhiliangLb.text = _hangbanNoStr;//@"深航UFO007";
    fuwuzhiliangLb.textAlignment = NSTextAlignmentCenter;
    fuwuzhiliangLb.font = [UIFont systemFontOfSize:14];
    
    
    [view1 addSubview:dateLb];
    [view1 addSubview:xingqiLb];
    [view1 addSubview:area1];
    [view1 addSubview:area2];
    [view1 addSubview:time1];
    [view1 addSubview:time2];
    [view1 addSubview:totaltTime];
    [view1 addSubview:imgvw];
    [view1 addSubview:jichang1];
    [view1 addSubview:jichang2];
    [view1 addSubview:fuwuzhiliangLb];
    
    
    
    NSMutableArray * _nameLbArr  = [NSMutableArray array];
    for (int i = 0; i<_chengkexinxiAry.count; i++) {
        UIView * view2  = [[UIView alloc]initWithFrame:CGRectMake(0, 159+7+7 + 87*i, ScreenWidth, 135)];
        view2.backgroundColor = [UIColor whiteColor];
        
        UILabel * chengjirenLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 56, 16)];
        chengjirenLb.text = @"乘机人";
        chengjirenLb.textColor =[UIColor lightGrayColor];
        chengjirenLb.font = [UIFont systemFontOfSize:16];
        
        _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(82, 25, 70, 16)];
        _nameLb.text = _chengkexinxiAry[i][@"name"];
        _nameLb.font = [UIFont systemFontOfSize:16];
        //        NSLog(@"张三吗:%@",stringg);
        
        _shenfenzhengLb = [[UILabel alloc]initWithFrame:CGRectMake(82, 58, 235, 16)];
        NSString * sfz_a = _chengkexinxiAry[i][@"cardno"];
        NSString * sfz_b = [[NSString alloc]init];
        NSRange range_sfz=NSMakeRange (4, 10);//从第4位开始的10位数转换成****
        sfz_b= [sfz_a stringByReplacingCharactersInRange:range_sfz withString:@"****"];
        [_nameLbArr addObject:sfz_b];
        _shenfenzhengLb.text = [NSString stringWithFormat:@"身份证: %@",_nameLbArr[i]];
        _shenfenzhengLb.font = [UIFont systemFontOfSize:16];
        
        UILabel * _line1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 86, ScreenWidth-30, 1)];
        _line1.backgroundColor =rgba(240, 240, 240, 1);
        
        [view2 addSubview:chengjirenLb];
        [view2 addSubview:_nameLb];
        [view2 addSubview:_shenfenzhengLb];
        [view2 addSubview:_line1];
        
        [scrView addSubview:view2];
        
        
    }
    
    UILabel * shoujiLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 18, 76, 16)];
    shoujiLb.text = @"联系手机";
    shoujiLb.textColor =[UIColor lightGrayColor];
    shoujiLb.font = [UIFont systemFontOfSize:16];
    
    UILabel * _line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, ScreenWidth-30, 1)];
    _line2.backgroundColor =rgba(240, 240, 240, 1);
    
    _PhoneONLb = [[UILabel alloc]initWithFrame:CGRectMake(82, 18, 150, 16)];
    
    NSString * No_a =  _Phone_NoStr;
    NSString * No_b = [[NSString alloc]init];
    NSRange rangeNo=NSMakeRange (3, 5);//从第4位开始的10位数转换成****
    No_b= [No_a stringByReplacingCharactersInRange:rangeNo withString:@"****"];
    _PhoneONLb.text = No_b;
    _PhoneONLb.font = [UIFont systemFontOfSize:16];
    
    

    
    
    
    
    UIView * buttonVw = [[UIView alloc]initWithFrame:CGRectMake(0, 159+7+5+ 87*_chengkexinxiAry.count, ScreenWidth, 102)];
    buttonVw.backgroundColor = [UIColor whiteColor];
    
    UIButton * chakanBt = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 55, 59, 110, 17)];
    [chakanBt setTitle:@"查看加密信息" forState:UIControlStateNormal];
    [chakanBt setTitleColor:rgba(230, 87, 36, 1) forState:UIControlStateNormal];//ios—看.png
    chakanBt.backgroundColor = [UIColor whiteColor];
    [chakanBt addTarget:self action:@selector(pressjiamiBt:) forControlEvents:UIControlEventTouchUpInside];
    [chakanBt setFont:[UIFont systemFontOfSize:14]];
    [chakanBt setImage:[UIImage imageNamed:@"ios—看grm"] forState:UIControlStateNormal];

    //左图片//右文字
    [chakanBt setTitleEdgeInsets:UIEdgeInsetsMake(0, chakanBt.titleLabel.bounds.size.width, 0, chakanBt.titleLabel.bounds.size.width-20)];
    [chakanBt setImageEdgeInsets:UIEdgeInsetsMake(0, -chakanBt.imageView.bounds.size.width+15, 0, chakanBt.imageView.bounds.size.width)];
    
    
    [buttonVw addSubview:chakanBt];
    [buttonVw addSubview:_line2];
    [buttonVw addSubview:shoujiLb];
    [buttonVw addSubview:_PhoneONLb];
    
    
    
    
    [scrView addSubview:view1];
    //[scrView addSubview:view2];
    [scrView addSubview:buttonVw];
    
    
    
    //二,vw
    UIView * buttomVw= [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-59-64-100, ScreenWidth, 59+100)];
    buttomVw.backgroundColor = [UIColor whiteColor];
    
    zfbVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    zfbVw.backgroundColor = [UIColor whiteColor];
    UILabel * lineLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, ScreenWidth, 0.5f)];
    lineLb.backgroundColor = [UIColor lightGrayColor];
    UIImageView * zhifubaoImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(27, 16, 24, 24)];
    zhifubaoImgvw.image =[ UIImage imageNamed:@"alipay"];
     UILabel * zhifubaoLb = [[UILabel alloc]initWithFrame:CGRectMake(71, 19, 70, 17)];
    zhifubaoLb.text = @"支付宝";
    selectBt1 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, 16, 21, 21)];
    [selectBt1 setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [selectBt1 setImage:[UIImage imageNamed:@"选择后"] forState:UIControlStateSelected];
    [selectBt1 setTitleEdgeInsets:UIEdgeInsetsMake(0, selectBt1.titleLabel.bounds.size.width, 0, selectBt1.titleLabel.bounds.size.width-20)];
    [selectBt1 setImageEdgeInsets:UIEdgeInsetsMake(0, -selectBt1.imageView.bounds.size.width-35, 0, selectBt1.imageView.bounds.size.width+35)];
    selectBt1.selected = YES;

    [zfbVw addSubview:zhifubaoImgvw];
    [zfbVw addSubview:zhifubaoLb];
    [zfbVw addSubview:selectBt1];
    [zfbVw addSubview:lineLb];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView1)];
    [zfbVw addGestureRecognizer:tap1];
    

    weixinVw = [[UIView alloc]initWithFrame:CGRectMake(0, 51, ScreenWidth, 49)];
    weixinVw.backgroundColor = [UIColor whiteColor];
    UIImageView * weixinImgvw = [[UIImageView alloc]initWithFrame:CGRectMake(27, 16, 24, 24)];
    weixinImgvw.image =[ UIImage imageNamed:@"WeChat-pay"];
    UILabel * weixinLb = [[UILabel alloc]initWithFrame:CGRectMake(71, 19, 70, 17)];
    weixinLb.text = @"微信";
    selectBt2 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, 16, 21, 21)];
    [selectBt2 setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [selectBt2 setImage:[UIImage imageNamed:@"选择后"] forState:UIControlStateSelected];
    [selectBt2 setTitleEdgeInsets:UIEdgeInsetsMake(0, selectBt2.titleLabel.bounds.size.width, 0, selectBt2.titleLabel.bounds.size.width-20)];
    [selectBt2 setImageEdgeInsets:UIEdgeInsetsMake(0, -selectBt2.imageView.bounds.size.width-35, 0, selectBt2.imageView.bounds.size.width+35)];
    selectBt2.selected = NO;
    
    [weixinVw addSubview:weixinImgvw];
    [weixinVw addSubview:weixinLb];
    [weixinVw addSubview:selectBt2];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView2)];
    [weixinVw addGestureRecognizer:tap2];
    
    
    
    
    UIButton * zhifuBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, ScreenWidth-20, 50)];
    zhifuBt.backgroundColor = rgba(230, 87, 36, 1);
    [zhifuBt addTarget:self action:@selector(presszhifuBt) forControlEvents:UIControlEventTouchUpInside];
    [zhifuBt setTitle:@"支付" forState:UIControlStateNormal];

    
    [buttomVw addSubview:zfbVw];
    [buttomVw addSubview:weixinVw];

    
    [buttomVw addSubview:zhifuBt];
    
    NSLog(@"_zhuangtaiString:%@",_zhuangtaiString);
    if ([_zhuangtaiString isEqualToString:@"SUCCESS"]) {
        [self.view addSubview:buttomVw];
    }
    else{
        
        [SVProgressHUD showInfoWithStatus:@"订单已失效"];
        sleep(1.0f);
    }
    [self.view addSubview:scrView];
    
}
-(void)tapView1{
    
    _zfbORweixin = 1;
    selectBt1.selected = YES;
    if(selectBt2.selected == YES){
        selectBt2.selected =NO;
    }
    
}

-(void)tapView2{
    _zfbORweixin = 0;
    selectBt2.selected = YES;
    if(selectBt1.selected == YES){
        selectBt1.selected =NO;
    }
}
#pragma mark 显示隐藏信息
-(void)pressjiamiBt:(UIButton *)btn
{
    btn.selected  = !btn.selected;
    
    if (btn.selected) {
        for (int i = 0; i<_chengkexinxiAry.count; i++) {
            _shenfenzhengLb.text = [NSString stringWithFormat:@"身份证: %@",_chengkexinxiAry[i][@"cardno"]];
        }
        _PhoneONLb.text=_Phone_NoStr;
    }
    else{
        for (int i = 0; i<_chengkexinxiAry.count; i++) {
            
            NSString * sfz_a = _chengkexinxiAry[i][@"cardno"];
            NSString * sfz_b = [[NSString alloc]init];
            NSRange range_sfz=NSMakeRange (4, 10);//从第4位开始的10位数转换成****
            sfz_b= [sfz_a stringByReplacingCharactersInRange:range_sfz withString:@"****"];
            _shenfenzhengLb.text = [NSString stringWithFormat:@"身份证: %@",sfz_b];
        }
        
        NSString * No_a =  _Phone_NoStr;
        NSString * No_b = [[NSString alloc]init];
        NSRange rangeNo=NSMakeRange (3, 5);//从第4位开始的10位数转换成****
        No_b= [No_a stringByReplacingCharactersInRange:rangeNo withString:@"****"];
        _PhoneONLb.text = No_b;
        
    }
    
    
}

-(void)xingqizhuanhuan2:(NSString *)str{
    //年
    NSString * nian = [str substringToIndex:4];//截取前五位作为日期,第5位之前(不包含)的所有字符串
    
    //中转
    NSString * yue_And_ri = [str substringFromIndex:5];
    
    //月
    NSString * yue = [yue_And_ri substringToIndex:2];//
    
    //日
    NSString * ri = [yue_And_ri substringFromIndex:3];
    
    
    //    NSLog(@"%@,%@,%@",nian,yue,ri);
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[ri intValue]];
    [_comps setMonth:[yue intValue]];
    [_comps setYear:[nian intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    int _weekday = [weekdayComponents weekday];
    //    NSLog(@"_weekday::%d",_weekday);//以周日为第一天, 0=星期天,7=星期六
    
    switch (_weekday) {
        case 1:
            _xingqijiStr = @"星期天";
            break;
        case 2:
            _xingqijiStr = @"星期一";
            break;
        case 3:
            _xingqijiStr = @"星期二";
            break;
        case 4:
            _xingqijiStr = @"星期三";
            break;
        case 5:
            _xingqijiStr = @"星期四";
            break;
        case 6:
            _xingqijiStr = @"星期五";
            break;
        case 7:
            _xingqijiStr = @"星期六";
            break;
            
        default:
            break;
    }
}

//支付宝或者微信支付
-(void)presszhifuBt{
    
    
//    NSLog(@"最终的包括各种金额%f",_jiage);
    float jiage = [_jiageStr floatValue];
        NSLog(@"最终的包括各种金额%f",jiage);

    if (_zfbORweixin==0) {//微信
        NSLog(@"微信");
        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
        dataDic[@"token"]=[NSString getDefaultToken];//
        dataDic[@"orderid"]=[NSString stringWithFormat:@"%@",_orderid];//订单id
        dataDic[@"systemtradeno"]=[NSString stringWithFormat:@"%@",_orderno];//商品id
        dataDic[@"orderprice"]=[NSString stringWithFormat:@"%f",jiage];//,_jiage];//单位:元
        NSLog(@"微信字典%@",dataDic);
        [SVProgressHUD dismiss];
        [[PayTool defaltTool] payForServiceWithDic:dataDic withViewController:self withPayType:@"101" SuccessBlock:^{
            NSLog(@"SuccessBlock");
        } failure:^(NSString *errorInfo) {
            NSLog(@"failure:%@",errorInfo);
        }];
        
    }
    else if (_zfbORweixin==1)//支付宝
    {
        NSLog(@"支付宝");
        
        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
        dataDic[@"token"]=[NSString getDefaultToken];
        dataDic[@"orderid"]=[NSString stringWithFormat:@"%@",_orderid];//订单id
        dataDic[@"systemtradeno"]=[NSString stringWithFormat:@"%@",_orderno];////商品id,
        dataDic[@"orderprice"]=[NSString stringWithFormat:@"%f",jiage];//,_jiage];//单位:元
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





@end
